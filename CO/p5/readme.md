p5为流水线CPU，我目前仅按照《数字设计和计算机体系结构》一书中的框架搭建了流水线的CPU数据通路，实现了部分指令延迟槽。

指令集为{addu, subu, ori, lui, lw, sw, jal, jr, j, beq, nop}

未实现转发和暂停

不保证CPU模型的正确性！！仍有待改进，只能过课下弱测，强测过不了