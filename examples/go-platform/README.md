# Go Platform

The roc compiler has no knowloage, how to build a go-platform. [In the
future](https://roc.zulipchat.com/#narrow/stream/304641-ideas/topic/Platform.20host.20build.20process),
there will be a way for a platform to define the build process. For now, the
compiled roc binary and the go binary have to be manualy liked.

```bash
roc build --no-link
go build platform/main.go
./main
```
