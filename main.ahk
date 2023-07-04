SetTitleMatchMode(2)
#SingleInstance force
Hotstring("EndChars", " `t")

#Include helper.ahk
#Include extrakeyboard.ahk

#Include sup.ahk

ℵ0x(arg){
    Send("{U+" . arg . "}")
}
Hotstring ":*b0:ℵ0x", command("ℵ0x",ℵ0x)