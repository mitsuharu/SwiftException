# SwiftException

Swift の Runtime Exception はキャッチできるのかと試した話

## Fortify

Fortify.swift は [johnno1962/Fortify: Making Swift more robust](https://github.com/johnno1962/Fortify) から追加してください


## ライブラリ

ライブラリ [mitsuharu/MEOException: catch runtime exception for UITableView.reloadCells() in Swift](https://github.com/mitsuharu/MEOException) を公開しました．

# やりたいこと

Swiftの例外キャッチは ```throw``` を実装したメソッドに対して，行える．

```Swift
do{
	try hogehoge()
}catch{
	...
}
```

しかし，ランタイム例外は ```do-catch``` で囲ってもキャッチできない

```Swift
do{
	let temps = [0, 1, 2]
	print("\(temps[10])") // クラッシュ
	// try temps[10] // Xcodeに怒られる
}catch{
	...
}
```

上記の単純な配列indexぐらいなら事前に確認すれば問題ない．しかしながら，いくつもの処理が複雑で絡み合うシーンに出くわしたとき，サードライブラリなどで手出しができないとき，事前確認が複雑なときにそれらが起こす例外をキャッチしたいときがある．

Objective-Cはこれらの例外が取れていた．それなら，Swift内で例外をキャッチしたい処理をObjective-Cで行えばできるかなとやってみた．

# 処理をブロック化して例外をキャッチする

Objective-Cで，処理をブロックで渡して，例外が起こったときのコールバックを行うクラス ```ExcBlock``` を用意した．

ExcBlock.h

```Objective-C:ExcBlock.h
typedef void (^Block)(void);
typedef void (^Completion)( NSException *exception );

@interface ExcBlock : NSObject

+ (void)executeBlock:(Block)block completion:(Completion)completion;

@end
```

ExcBlock.m

```Objective-C
@implementation ExcBlock

+ (void)executeBlock:(Block)block completion:(Completion)completion
{
    @try {
        NSLog(@"execute block");
        block();
    } @catch (NSException *exception) {
        NSLog(@"exception = %@", exception);
        completion(exception);
    } @finally {
    }
}

@end
```

Swift で呼び出して，故意に例外を起こして確認した．しかしながら，ブロック内の例外がキャッチされることはなく，そのままクラッシュした．

```Swift
ExcBlock.execute({
            let temps = [0, 1, 2]
            print("\(temps[10])")
            // ブロックの中で起こる例外がキャッチできないまま落ちる
        }) { (exception) in
            print(exception)
        }
```

# 個別に例外をキャッチする

汎用的にSwiftのコードをブロックで渡したからキャッチできなかったと考えた．処理を丸々Objective-Cに渡してみたらどうだろうか．クラスを上書きして，例外が起こる箇所の専用メソッドを用意する．

仮に UITableView の reloadRows の例外をキャッチする関数を用意した．

```Objective-C
typedef void (^ExcCompletion)( NSException *exception );

@interface ExcTableView : UITableView

- (void)exc_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
                  withRowAnimation:(UITableViewRowAnimation)animation
                     excCompletion:(ExcCompletion)excCompletion;

@end
```

```Objective-C
@implementation ExcTableView

- (void)exc_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
                  withRowAnimation:(UITableViewRowAnimation)animation
                         excCompletion:(ExcCompletion)excCompletion{
    
    @try {
        [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    } @catch (NSException *exception) {
        excCompletion(exception);
    } @finally {
    }    
}

@end
```

Swiftでは故意に例外が起こるようにようにしたところ，アプリはクラッシュせずに例外を取得できた．しかしながら，個別にメソッドを用意しなければならないので現実的ではない．


```Swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ip = IndexPath(row: 100, section: 100)

        self.tableView.exc_reloadRows(at: [ip], with: UITableView.RowAnimation.automatic) { (exception) in
            print("[exc_reloadRows] exception:\(exception)")
            // 無事に "[exc_reloadRows] exception:attempt to delete row 100 from section 100, but there are only 1 sections before the update
" が標準出力に表示された
        }
    }
```
    

