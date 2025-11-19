" ==============================================================================
" 插件名称：CPC（Chinese Punctuation Converter）中文标点转换器
" 功能：一键转换中文标点、序号为英文格式，支持自定义配置
" 安装：放入 ~/.vim/plugin/ 目录，Vim自动加载
" 使用：默认F4快捷键，或输入 :ReplacePunct 执行
" ==============================================================================

" ===================== 可自定义配置（.vimrc中覆盖）=====================
" 1. 标点后是否加空格（1=加，0=不加，LaTeX用户建议0）
if !exists('g:cpc_add_space')
  let g:cpc_add_space = 1
endif

" 2. 书名号替换（0=不换，1=<>，2=LaTeX斜体）
if !exists('g:cpc_bookmark')
  let g:cpc_bookmark = 1
endif

" 3. 自定义快捷键（如 let g:cpc_key = '<leader>pc'）
if !exists('g:cpc_key')
  let g:cpc_key = '<F4>'
endif

" ===================== 核心转换函数（命名空间和文件名一致）=====================
function! cpc#Convert() abort
  " 配置映射（根据用户设置决定是否加空格）
  let s:comma    = g:cpc_add_space ? ', ' : ','
  let s:period   = g:cpc_add_space ? '. ' : '.'
  let s:colon    = g:cpc_add_space ? ': ' : ':'
  let s:semicolon= g:cpc_add_space ? '; ' : ';'
  let s:question = g:cpc_add_space ? '? ' : '?'
  let s:exclam   = g:cpc_add_space ? '! ' : '!'

  " 1. 核心标点
  %s/，/\=s:comma/ge
  %s/。/\=s:period/ge
  %s/、/\=s:comma/ge
  %s/：/\=s:colon/ge
  %s/；/\=s:semicolon/ge
  %s/？/\=s:question/ge
  %s/！/\=s:exclam/ge

  " 2. 引号/括号
  %s/“/"/ge
  %s/”/"/ge
  %s/‘/'/ge
  %s/’/'/ge
  %s/（/(/ge
  %s/）/)/ge

  " 3. 特殊符号
  %s/｜/\|/ge
  %s/–/-/ge
  %s/—/--/ge
  %s/…/.../ge
  %s/●/•/ge
  %s/○/o/ge
  %s/·/./ge

  " 4. 中文序号→阿拉伯数字
  %s/①/1/ge
  %s/②/2/ge
  %s/③/3/ge
  %s/④/4/ge
  %s/⑤/5/ge
  %s/⑥/6/ge
  %s/⑦/7/ge
  %s/⑧/8/ge
  %s/⑨/9/ge
  %s/⑩/10/ge

  " 5. 书名号处理
  if g:cpc_bookmark == 1
    %s/《/</ge
    %s/》/>/ge
  elseif g:cpc_bookmark == 2
    %s/《/\\textit{/ge
    %s/》/}/ge
  endif

  echom "[CPC] 标点转换完成！"
endfunction

" ===================== 命令和快捷键 =====================
command! -nargs=0 ReplacePunct call cpc#Convert()
execute 'nnoremap <silent> ' . g:cpc_key . ' :ReplacePunct<CR><Esc>'

