#!/usr/bin/env python3
"""Generate development report PDF for MoonTemplate."""
from fpdf import FPDF

pdf = FPDF("P", "mm", "A4")
pdf.set_auto_page_break(True, 18)
pdf.add_font("CJK", "", r"C:\Windows\Fonts\msyh.ttc")
pdf.add_font("CJK", "B", r"C:\Windows\Fonts\msyhbd.ttc")

pdf.add_page()
pdf.set_font("CJK", "B", 18)
pdf.set_text_color(33, 66, 52)
pdf.cell(0, 12, "MoonTemplate 开发报告", align="C")
pdf.ln(16)

sections = [
    ("项目概述", "MoonTemplate 是一个纯 MoonBit 实现的 Handlebars 风格模板引擎。参考 Handlebars.js（MIT），使用 MoonBit 原生类型系统重新设计，提供变量插值、条件渲染、循环遍历、注释和 HTML 自动转义。"),
    ("技术架构", "Template String -> Lexer -> Token Stream -> Parser -> AST -> Renderer -> Output String\n\n核心设计：递归下降解析 + Array[(String,String)]上下文 + 零外部依赖。"),
    ("实现内容", "Lexer：{{}} 分隔符识别、块开闭标记、else特殊标记、注释支持\nParser：parse_until递归下降、块嵌套、else/unless停止条件\nRenderer：变量查找、HTML自动转义、条件/循环求值\n新增0.2.0：注释语法({{! }}和{{!-- --}})、unless指令"),
    ("测试结果", "变量插值：2个\n非转义输出：1个\nHTML转义：2个\n条件渲染：4个\nUnless指令：4个\n注释：2个\n循环遍历：2个\n混合模板：2个\n编译复用：1个\n边界情况：2个\n合计：25+个，全部通过\n编译：0错误"),
    ("项目统计", "MoonBit源码：约620行\n包数量：4个（types/lexer/parser/render）\nGit提交：15次\n依赖：零外部依赖"),
    ("适用场景", "MoonBit Web应用服务端渲染、静态站点生成器模板引擎、HTML邮件模板生成、文档自动化工具。"),
    ("后续计划", "1. 增加更多内置Helper（with、partial）\n2. 支持文件系统模板加载\n3. 发布至mooncakes.io"),
]

for title, content in sections:
    pdf.set_font("CJK", "B", 13)
    pdf.set_text_color(33, 66, 52)
    pdf.cell(0, 9, title)
    pdf.ln(10)
    pdf.set_font("CJK", "", 10)
    pdf.set_text_color(60, 60, 60)
    for line in content.split("\n"):
        pdf.cell(0, 6.5, line)
        pdf.ln(6.5)
    pdf.ln(4)

pdf.output("docs/competition/MoonTemplate开发报告.pdf")
print("Done: docs/competition/MoonTemplate开发报告.pdf")
