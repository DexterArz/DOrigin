# vs-code extensions to  install 
- [ ] Git blame
- [ ] git-autoconfig (shyykoserhiy)


# Git setup 

```
git config --global user.name ""
git config --global user.email ""


git config --global core.editor " codium --wait"
git config --global core.autocrlf "input"

```

##### Pager Interference: In some environments (like VS Code or Oh-My-Zsh), output may pipe to less or appear empty due to pager settings. You can disable the pager globally by running
```
git config --global pager.log false
```

# basic comands 
### 1. initialize
```
git init 
```
*it makes git avalable inside the folder , so basically the first step*
### 2. Add
```
git add <file.name>
```
*this command start tracking the file which you have added*
### 3. commit 
```
git commit 
```
*creates a check point*
### 4. logs
```
git log --oneline
```
*is used to know  current status of saved points*

### 5. ignore file
```
.gitignore
```
*Not actually a command but a file that tells git which file he should ignore and not track*

### 6. git reset
```
git reset --hard 

git reset --soft

git reset --mixed
```
*these comands helps in restoring previous commits*
#### we can use 
```
git reset --hard HEAD~1
```
#### HEAD~1 means go one steps back

### 7. git status
```
git status -s
git status 
```
*used to check the status of the file
which file is tracked 
which file is modified 
which file is untracked*
### 8. branch
```
git branch <branch Name>
```
*its basically a coppy of the latest commit*
### 9. switch 
```
git switch <branch Name>
```
*its used to change current working branch*

: