# Requirememts
1. Send an email to a configured email address when any of the following events are logged within CloudTrail: (not done)
    - Unauthorised API calls
    - Management Console sign-in without MFA 
    - Usage of the "root" account

# Notes:
- to create an alarm, a metric filter must be created first
    - try to set up in console to see how this works
- cloudtrail depends on cloudwatch (the way I've set it up) so run cloudwatch first.
