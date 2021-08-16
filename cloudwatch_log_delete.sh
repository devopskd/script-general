# Lambda Function
# Using below command  you can delete log streams based on the date. The logStreamName is appended with date. Using this date you can search the 
# log streams which are not required any more. The below example searches all the log streams within a log group for year 2018. In the 
# name prefix for log stream it searches for all streams starting with "2". Then based on $log_stream_name_not_to_delete value, it deletes 
# all log stream except for the date defined in $log_stream_name_not_to_delete.

#set the log group name
$log_group_name = "/aws/lambda/getlocationbyid"
$log_stream_name_not_to_delete = "2018/10*"

aws logs describe-log-streams --log-group-name $log_group_name --log-stream-name-prefix "2" --query logStreams --output json | ConvertFrom-json |ForEach-Object {$_.logStreamName} | ForEach-Object {
   if ($_ -like   $log_stream_name_not_to_delete) {write-host ($_ + " : NOT DELETED") -ForegroundColor Red}` else {Write-Host ($_ + " : DELETED") -ForegroundColor Green  
   aws logs delete-log-stream --log-group-name $log_group_name --log-stream-name $_ }}