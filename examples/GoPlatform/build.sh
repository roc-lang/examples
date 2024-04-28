GOOS=linux GOARCH=arm64 go build -C host -buildmode=c-archive -o libhost.a
cp host/libhost.a platform/macos-arm64.a

roc dev --prebuilt-platform main.roc