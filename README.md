# CMAKE の target_link_libraries を列挙するのに使うスクリプト

## 使い方
例のために make すると
a.so 自分自身で完結
b.so a.so に依存
c.so a.so と b.so に依存
の三つの(a.so b.so c.so) のライブラリが出来ます。

$ perl target_link_libraries.pl a.so b.so c.so
_ITM_registerTMCloneTable is not resolved
__gmon_start__ is not resolved
__cxa_finalize@@GLIBC_2.2.5 is not resolved
_ITM_deregisterTMCloneTable is not resolved
target_link_libraries( c.so PRIVATE b.so a.so )
target_link_libraries( b.so PRIVATE a.so )

で、依存関係が出力されます。

## やってること
 nm でシェアードオブジェクトのシンボルを全部出します。
 perl でnmの出力から未解決シンボルを順番に解決して、シンボル単位で依存関係を見ていきます。
 最後に target_link_libraries を出力します


 


