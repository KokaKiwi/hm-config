set _usage_spec_@baseName@ (@usageCmd@ | string collect)
complete -xc @exeName@ -a '(@usageBin@ complete-word -s "$_usage_spec_@baseName@" -- (commandline -cop) (commandline -t))'
