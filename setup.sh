#!/bin/sh
##
# 各種dotファイルリンク作成
# vimのバックアップスワップファイル置き場作成
##

# リンク作成
for file in `ls -A`
do
if [ $file != 'setup.sh' -a $file != 'README.md' -a $file != '.git' ]; then
    if [ -a $HOME/$file ]; then
        echo "既にファイルが存在します: $file"
    else 
        #ln -s $HOME/dotfiles/$file $HOME/$file
        echo "シンボリックリンクを張りました: $file"
    fi
fi
done

# viのテンプファイル・ディレクトリ作成
vimtmp=".vimswap .vimbackup"
for tmp in $vimtmp
do
    if [ -a $HOME/$tmp ]; then
        echo "ディレクトリがあります: $tmp"
    else
        mkdir  $HOME/$tmp
        echo "ディレクトリを作成しました: $tmp"
    fi
done

