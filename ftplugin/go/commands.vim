command! -nargs=* -range AddTags call go#tags#Add(<line1>, <line2>, <count>, <f-args>)
command! -nargs=* -range RemoveTags call go#tags#Remove(<line1>, <line2>, <count>, <f-args>)
