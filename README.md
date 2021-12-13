# devops-netology_navasardyan
MyFirstProjectOnGit
These files will be ignored in directory /terraform :
*.tfstate
*.tfstate.*
crash.log
*.tfvars
override.tf
override.tf.json
*_override.tf
*_override.tf.json
.terraformrc
terraform.rc

Hello from PyCharm

Домашнее задание к занятию «2.4. Инструменты Git»
# 1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.

### git log --pretty=oneline | grep aefea
### aefead2207ef7e2aa5dc81a34aedf0cad4c32545 Update CHANGELOG.md (то что искали)
### 8619f566bbd60bbae22baefea9a702e7778f8254 validate providers passed to a module exist
### 3593ea8b0aefea1b4b5e14010b4453917800723f build: Remove format check from plugin-dev
###  0196a0c2aefea6b85f495b0bbe32a855021f0a24 Changed Required: false to Optional: true in the ### SNS topic schema

# 2.Какому тегу соответствует коммит 85024d3?
### git show 85024d3
### commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
### Author: tf-release-bot <terraform@hashicorp.com>
### Date:   Thu Mar 5 20:56:10 2020 +0000

###    v0.12.23

### diff --git a/CHANGELOG.md b/CHANGELOG.md
### index 1a9dcd0f9..faedc8bf4 100644
### --- a/CHANGELOG.md
### +++ b/CHANGELOG.md
### @@ -1,4 +1,4 @@
### -## 0.12.23 (Unreleased)
### +## 0.12.23 (March 05, 2020)
### 0.12.22 (March 05, 2020)

### ENHANCEMENTS:
### diff --git a/version/version.go b/version/version.go
### index 33ac86f5d..bcb6394d2 100644
### --- a/version/version.go
### +++ b/version/version.go
### @@ -16,7 +16,7 @@ var Version = "0.12.23"
###  // A pre-release marker for the version. If this is "" (empty string)
###  // then it means that it is a final release. Otherwise, this is a pre-release
###  // such as "dev" (in development), "beta", "rc1", etc.
### -var Prerelease = "dev"
### +var Prerelease = ""

# 3.Сколько родителей у коммита b8d720? Напишите их хеши.
### git show --pretty=format:' %P' b8d720
###  56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b

# 4.Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
### git log  v0.12.23..v0.12.24  --oneline
### 33ff1c03b (tag: v0.12.24) v0.12.24
### b14b74c49 [Website] vmc provider links
### 3f235065b Update CHANGELOG.md
### 6ae64e247 registry: Fix panic when server is unreachable
### 5c619ca1b website: Remove links to the getting started guide's old location
### 06275647e Update CHANGELOG.md
### d5f9411f5 command: Fix bug when using terraform login on Windows
### 4b6d06cc5 Update CHANGELOG.md
### dd01a3507 Update CHANGELOG.md
### 225466bc3 Cleanup after v0.12.23 release

# 5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).

### git log -S'func providerSource' --oneline
### 5af1e6234 main: Honor explicit provider_installation CLI config when present
### 8c928e835 main: Consult local directories as potential mirrors of providers

# 6.Найдите все коммиты в которых была изменена функция globalPluginDirs.
### git log -L :'func globalPluginDirs':plugins.go --oneline 

# 7.Кто автор функции synchronizedWriters?
###  git log -S'func synchronizedWriters' --pretty=format:'%h - %an %ae'
### bdfea50cc - James Bardin j.bardin@gmail.com
### 5ac311e2a - Martin Atkins mart@degeneration.co.uk
