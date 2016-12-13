*How to use gdb*
When driver panic, there will be a panic showing:
	XXX_ximt_hw+0x100/0x1e0[XXX]
then, how can I identify the issue? Here is a way to do.
use command:
	
	aarch64-linux-gnu-gdb XXX.o
	(gdb) l * XXX_xmit_hw+0x100

	

