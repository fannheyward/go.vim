" -- tags
command! -nargs=* -range GoAddTags call go#tags#Add(<line1>, <line2>, <count>, <f-args>)
command! -nargs=* -range GoRemoveTags call go#tags#Remove(<line1>, <line2>, <count>, <f-args>)

" -- fmt
command! -buffer GoFmt call go#fmt#Format()

" -- alternate
command! -bang GoAlternate call go#alternate#Switch(<bang>0, '')

" vim: sw=2 ts=2 et
