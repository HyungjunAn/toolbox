#include lib_common.ahk

$Capslock::Ctrl

$^Delete:: ExitApp

$!+a::
{
	Run TOOLBOX_ROOT_AHK . "\main.ahk"
	ExitApp
}
