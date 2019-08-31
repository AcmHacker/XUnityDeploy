# #!/bin/bash
cd $1
xcodebuild clean
xcodebuild archive -project Unity-iPhone.xcodeproj -scheme Unity-iPhone -UseModernBuildSystem=NO -archivePath $3
xcodebuild -exportArchive -exportOptionsPlist $2 -archivePath $3 -exportPath $4
