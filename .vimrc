" vim: set ts=4 sw=4 sts=0:

"-----------------------------------------------------------------------------
" OS毎の設定ファイル
"
if has('win32')
	:let $VIMFILE_DIR = 'vimfiles'
else
	:let $VIMFILE_DIR = '.vim'
endif

"-----------------------------------------------------------------------------
" 文字コード関連
"
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
	" iconvがeucJP-msに対応しているかをチェック
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'eucjp-ms'
		let s:enc_jis = 'iso-2022-jp-3'
	" iconvがJISX0213に対応しているかをチェック
	elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	" fileencodingsを構築
	if &encoding ==# 'utf-8'
		let s:fileencodings_default = &fileencodings
		let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
		let &fileencodings = &fileencodings .','. s:fileencodings_default
		unlet s:fileencodings_default
	else
		let &fileencodings = &fileencodings .','. s:enc_jis
		set fileencodings+=utf-8,ucs-2le,ucs-2
		if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			set fileencodings+=cp932
			set fileencodings-=euc-jp
			set fileencodings-=euc-jisx0213
			set fileencodings-=eucjp-ms
			let &encoding = s:enc_euc
			let &fileencoding = s:enc_euc
		else
			let &fileencodings = &fileencodings .','. s:enc_euc
		endif
	endif
	" 定数を処分
	unlet s:enc_euc
	unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
	set ambiwidth=double
endif

"-----------------------------------------------------------------------------
" バックアップ設定
"
set swapfile
set directory=~/.vimswap

set backup
set backupdir=~/.vimbackup

"-----------------------------------------------------------------------------
" 編集関連
"
"オートインデントする
"set autoindent
" 自動インデント
set smartindent
 
"バイナリ編集(xxd)モード（vim -b での起動、もしくは *.bin で発動します）
augroup BinaryXXD
	autocmd!
	autocmd BufReadPre  *.bin let &binary =1
	autocmd BufReadPost * if &binary | silent %!xxd -g 1
	autocmd BufReadPost * set ft=xxd | endif
	autocmd BufWritePre * if &binary | %!xxd -r | endif
	autocmd BufWritePost * if &binary | silent %!xxd -g 1
	autocmd BufWritePost * set nomod | endif
augroup END

"-----------------------------------------------------------------------------
" 検索関連
"
"検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
"検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
"検索時に最後まで行ったら最初に戻る
set wrapscan
"検索文字列入力時に順次対象文字列にヒットさせない
set noincsearch
" バックスペースでインデントや改行を削除できるようにする
"set backspace=2
"eol:改行,start:入力モードに入る前の文字
set backspace=indent,eol,start
" インクリメンタルサーチを有効にする
set incsearch

"-----------------------------------------------------------------------------
" 装飾関連
"
"シンタックスハイライトを有効にする
highlight Comment ctermfg=blue guifg=blue
"行番号を表示する
set number
"タブの左側にカーソル表示
set listchars=tab:\ \ 
set list
"タブ幅を設定する
set tabstop=4
set shiftwidth=4
set ts=4
set expandtab
" EC-CUBEはインデント空白
" set noexpandtab

" C-v の矩形選択で行末より後ろもカーソルを置ける
set virtualedit=block
"入力中のコマンドをステータスに表示する
set showcmd
"括弧入力時の対応する括弧を表示
set showmatch
"検索結果文字列のハイライトを有効にする
set hlsearch
"ステータスラインを常に表示
set laststatus=2
"ステータスラインに文字コードと改行文字を表示する
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
" 全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white
match ZenkakuSpace /　/

highlight zenkakuda cterm=underline ctermfg=black guibg=black
if has('win32') && !has('gui_running')
	" win32のコンソールvimはsjisで設定ファイルを読むので、
	" sjisの全角スペースの文字コードを指定してやる
	match zenkakuda /\%u8140/
else
	match zenkakuda /　/
endif

" ウィンドウ幅に合わせて自動改行しない
set nowrap
" 上下から､指定した行数に達したら自動ｽｸﾛｰﾙ
set scrolloff=5
" 強化されたｺﾏﾝﾄﾞﾗｲﾝ補完を使用
set wildmenu
" バッファ切替時オートセーブ
set autowrite
" commandline
set cmdheight=2
" tab設定
set showtabline=1
" 256色
set t_Co=256

" powerline用フォント
set guifont=RictyForPowerline-Regular:h16

"-----------------------------------------------------------------------------
" マップ定義
"
"バッファ移動用キーマップ
" F2: 前のバッファ
" F3: 次のバッファ
" F4: バッファ削除
map <F2> <ESC>:bp<CR>
map <F3> <ESC>:bn<CR>
map <F4> <ESC>:bw<CR>
"表示行単位で行移動する
nnoremap j gj
nnoremap k gk
"フレームサイズを怠惰に変更する
map <kPlus> <C-W>+
map <kMinus> <C-W>-

" コマンドモードで Emacs キーバインド
cmap <C-A> <Home>
cmap <C-F> <Right>
cmap <C-B> <Left>
cmap <C-D> <Delete>
cmap <Esc>b <S-Left>
cmap <Esc>f <S-Right>

"-----------------------------------------------------------------------------
"関数名補完
function InsertTabWrapper()
    if pumvisible()
        return "\<c-n>"
    endif
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k\|<\|/'
        return "\<tab>"
    elseif exists('&omnifunc') && &omnifunc == ''
        return "\<c-n>"
    else
        return "\<c-x>\<c-o>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
:setlocal omnifunc=syntaxcomplete#Complete

"-----------------------------------------------------------------------------
" キーマクロ
"
" php用 var_dump
func! WritePRE()
    let lf = "\n"
    let var    = "$var = $;"
    let pre1   = "echo '<pre>';"
    let print  = "var_dump($var);"
    let pre2   = "echo '</pre>';"
    let exit   = "exit;"
    execute "normal!  i".var.lf.pre1.lf.print.lf.pre2.lf.exit."\<ESC>--f)"
    execute "normal kk"
    execute "startinsert"
endfunc
command PRE :call WritePRE()

"-----------------------------------------------------------------------------
"snippets
if exists('loaded_snippet')
    imap <C-B> <Plug>Jumper
endif
filetype plugin on

"set mouse=a
set ttymouse=xterm2

"-----------------------------------------------------------------------------
"php setting
set foldmethod=syntax
let php_sql_query=1
let php_htmlInStrings=1
let php_folding=1
set foldlevel=100

"-----------------------------------------------------------------------------
"vundle 
set nocompatible              " be iMproved
filetype off                  " required!

" Vundle を初期化して
" Vundle 自身も Vundle で管理
" set rtp+=~/.vim/vundle.git/
" call vundle#rc()

" neobundle
set rtp+=~/.vim/bundle/neobundle.vim

if has('vim_starting')
"  set runtimepath+=~/dotfiles/neobundle.vim
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  call neobundle#rc(expand('~/.vim/bundle/'))
endif

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc', {
            \ 'build' : {
            \     'windows' : 'make -f make_mingw64.mak',
            \     'cygwin' : 'make -f make_cygwin.mak',
            \     'mac' : 'make -f make_mac.mak',
            \     'unix' : 'make -f make_unix.mak',
            \ }}
NeoBundle 'Shougo/vimshell'

NeoBundle 'taichouchou2/alpaca_powertabline'
NeoBundle 'Lokaltog/powerline', { 'rtp' : 'powerline/bindings/vim'}

NeoBundle 'The-NERD-tree'
NeoBundle 'minibufexpl.vim'

NeoBundle 'vim-scripts/svn-diff.vim'

NeoBundle 'mattn/zencoding-vim'
NeoBundle 'YankRing.vim'

NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'

filetype plugin indent on     " required!

" NERDTree
" トグルをキーマップ
nnoremap <f12> :NERDTreeToggle<CR>
" ディレクトリツリー装飾ON
let g:NERDTreeDirArrows=0
" メニューUI表示
let g:NERDTreeMinimalUI=0
" カラースキーマ設定
let g:NERDChristmasTree=1
let g:NERDTreeHighlightCursorline=1

" minibufexpl
:let g:miniBufExplMapWindowNavVim = 1
:let g:miniBufExplMapWindowNavArrows = 1
:let g:miniBufExplMapCTabSwitchBuffs = 1

" zencoding-vim
:let g:user_zen_settings = { 'indentation' : '    ' }
:let g:user_zen_expandabbr_key = '<c-e>'

" , y でヤンク履歴
" YankRing.vim
" http://nanasi.jp/articles/vim/yankring_vim.html
" https://github.com/yuroyoro/dotfiles/blob/master/.vimrc.plugins_setting
nmap ,y :YRShow<CR>


" Unite.vim
" key map
" ファイル一覧
noremap <C-U><C-F> :UniteWithBufferDir -buffer-name=files file<CR>

" レジスタ一覧
noremap <C-U><C-Y> :Unite -buffer-name=register register<CR>

"" neocomplcache
"" 補完ウィンドウの設定
"set completeopt=menuone
" 
"" 起動時に有効化
"let g:neocomplcache_enable_at_startup = 1
" 
"" 大文字が入力されるまで大文字小文字の区別を無視する
"let g:neocomplcache_enable_smart_case = 1
" 
"" _(アンダースコア)区切りの補完を有効化
"let g:neocomplcache_enable_underbar_completion = 1
" 
"let g:neocomplcache_enable_camel_case_completion  =  1
" 
"" ポップアップメニューで表示される候補の数
"let g:neocomplcache_max_list = 20
" 
"" シンタックスをキャッシュするときの最小文字長
"let g:neocomplcache_min_syntax_length = 3
" 
"" ディクショナリ定義
"let g:neocomplcache_dictionary_filetype_lists = {
"    \ 'default' : ''
"    \ }
"
"if !exists('g:neocomplcache_keyword_patterns')
"        let g:neocomplcache_keyword_patterns = {}
"endif
"let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
" 
"" スニペットを展開する。スニペットが関係しないところでは行末まで削除
"imap <expr><C-k> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-o>D"
"smap <expr><C-k> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-o>D"
" 
"" 前回行われた補完をキャンセルします
"inoremap <expr><C-g> neocomplcache#undo_completion()
" 
"" 補完候補のなかから、共通する部分を補完します
"inoremap <expr><C-l> neocomplcache#complete_common_string()
" 
"" 改行で補完ウィンドウを閉じる
"inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"
" 
""tabで補完候補の選択を行う
"inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
"inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"
" 
"" <C-h>や<BS>を押したときに確実にポップアップを削除します
"inoremap <expr><C-h> neocomplcache#smart_close_popup().”\<C-h>”
" 
"" 現在選択している候補を確定します
"inoremap <expr><C-y> neocomplcache#close_popup()
" 
"" 現在選択している候補をキャンセルし、ポップアップを閉じます
"inoremap <expr><C-e> neocomplcache#cancel_popup()
"
syntax on
