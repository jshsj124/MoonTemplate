#!/usr/bin/env python3
"""Generate proposal PDF with elegant Chinese typography style."""

from fpdf import FPDF


class ProposalPDF(FPDF):
    def __init__(self):
        super().__init__("P", "mm", "A4")
        self.set_auto_page_break(True, 18)
        self.add_font("Kai", "", r"C:\Windows\Fonts\STKAITI.TTF")
        self.add_font("Song", "", r"C:\Windows\Fonts\STSONG.TTF")
        self.add_font("SongB", "", r"C:\Windows\Fonts\SIMLI.TTF")
        self.add_font("Hei", "", r"C:\Windows\Fonts\STXIHEI.TTF")

        # Colors
        self.primary = (33, 66, 52)       # dark green
        self.accent = (82, 139, 116)       # sage
        self.light_bg = (235, 245, 240)    # mint
        self.text = (60, 60, 60)
        self.gray = (120, 120, 120)

    def header(self):
        if self.page_no() > 1:
            self.set_font("Kai", "", 9)
            self.set_text_color(*self.gray)
            self.cell(0, 5, "MoonTemplate — 项目申报书", align="R")
            self.ln(6)

    def footer(self):
        self.set_y(-15)
        self.set_font("Song", "", 8)
        self.set_text_color(*self.gray)
        self.cell(0, 10, f"— {self.page_no()} —", align="C")

    def section_box(self, title, content_lines):
        """Draw a section as a styled box with title."""
        # Title bar
        self.set_fill_color(*self.primary)
        self.set_text_color(255, 255, 255)
        self.set_font("Kai", "", 13)
        self.cell(0, 9, "  " + title, fill=True, ln=True)

        # Content area
        self.set_fill_color(*self.light_bg)
        y_start = self.get_y()
        self.set_font("Song", "", 10)
        self.set_text_color(*self.text)

        # Calculate height
        line_h = 6.5
        total_h = len(content_lines) * line_h + 6
        self.rect(10, y_start, 190, total_h, style="DF")

        self.set_xy(14, y_start + 3)
        for line in content_lines:
            self.set_x(14)
            self.cell(182, line_h, line)
            self.ln(line_h)

        self.set_y(y_start + total_h + 4)

    def bullet_list(self, items):
        """Draw a bulleted list."""
        self.set_font("Song", "", 10)
        self.set_text_color(*self.text)
        for item in items:
            self.cell(8, 6.5, "  ◆")
            self.cell(0, 6.5, item)
            self.ln(6.5)

    def body_text(self, text):
        self.set_font("Song", "", 10)
        self.set_text_color(*self.text)
        self.multi_cell(0, 6.5, text)
        self.ln(2)

    def small_label(self, label, value):
        self.set_font("Kai", "", 10)
        self.set_text_color(*self.primary)
        self.cell(36, 7, label)
        self.set_font("Song", "", 10)
        self.set_text_color(*self.text)
        self.cell(0, 7, value)
        self.ln(7)

    def divider(self):
        self.set_draw_color(*self.accent)
        y = self.get_y()
        self.line(14, y, 196, y)
        self.ln(4)


def build():
    pdf = ProposalPDF()
    pdf.add_page()

    # ── Hero Title ──
    pdf.set_fill_color(*pdf.primary)
    pdf.rect(0, 0, 210, 48, style="F")

    pdf.set_y(10)
    pdf.set_font("Kai", "", 26)
    pdf.set_text_color(255, 255, 255)
    pdf.cell(0, 14, "MoonTemplate", align="C")
    pdf.ln(14)
    pdf.set_font("Song", "", 12)
    pdf.set_text_color(200, 220, 210)
    pdf.cell(0, 8, "Handlebars 风格模板引擎 — MoonBit 移植", align="C")
    pdf.ln(16)

    # Subtitle
    pdf.set_text_color(*pdf.gray)
    pdf.set_font("Song", "", 9)
    pdf.cell(0, 6, "2026 MoonBit 国产开源生态竞赛", align="C")
    pdf.ln(14)

    # ── Basic Info ──
    pdf.section_box("基本信息", [])
    pdf.set_y(pdf.get_y() - 2)
    pdf.small_label("项目名称", "MoonTemplate：Handlebars 风格模板引擎的 MoonBit 移植")
    pdf.small_label("项目方向", "MoonBit 基础库 / Web 开发基础设施")
    pdf.small_label("移植项目", "是 — 参考 Handlebars.js（MIT）")
    pdf.small_label("许可证", "MIT")
    pdf.small_label("GitHub 仓库", "https://github.com/jshsj124/MoonTemplate")
    pdf.small_label("GitLink 仓库", "https://gitlink.org.cn/JshsJ/moontemplate")
    pdf.ln(4)

    # ── Project Introduction ──
    pdf.divider()
    pdf.set_font("Kai", "", 15)
    pdf.set_text_color(*pdf.primary)
    pdf.cell(0, 10, "项目简介")
    pdf.ln(12)

    pdf.body_text(
        "MoonTemplate 是一个纯 MoonBit 实现的 Handlebars 风格模板引擎，"
        "将模板字符串与上下文数据结合，生成结构化的 HTML 输出。"
        "MoonBit 生态中目前缺乏模板引擎，Web 开发场景中的 HTML 生成"
        "依赖于手动字符串拼接，缺乏安全、结构化的模板方案。本项目填补这一空白。"
    )

    # ── Core Features ──
    pdf.divider()
    pdf.set_font("Kai", "", 15)
    pdf.set_text_color(*pdf.primary)
    pdf.cell(0, 10, "核心功能")
    pdf.ln(12)

    pdf.bullet_list([
        "变量插值：{{ name }}，自动 HTML 转义防止 XSS 攻击",
        "非转义输出：{{{ html }}}，用于可信任的 HTML 片段",
        "条件渲染：{{#if condition}}...{{/if}}，完整支持 {{else}} 分支",
        "循环遍历：{{#each items}}...{{/each}}，逗号分隔集合迭代",
        "编译复用：compile 预编译模板，render 支持不同上下文多次渲染",
        "命令行演示工具，开箱即用",
        "零外部依赖，纯 MoonBit 实现，跨 Native/Wasm/JS 三端编译",
    ])

    # ── Porting Notes ──
    pdf.divider()
    pdf.set_font("Kai", "", 15)
    pdf.set_text_color(*pdf.primary)
    pdf.cell(0, 10, "移植说明")
    pdf.ln(12)

    pdf.body_text(
        "原项目 Handlebars.js（https://github.com/handlebars-lang/handlebars.js），"
        "MIT 许可证。本项目使用 MoonBit 原生类型系统重新设计架构："
        "Lexer 词法分析 → Parser 构建 AST → Renderer 求值输出。"
        "优先实现核心模板功能，弱化 Partials、Helper 注册等高级特性；"
        "上下文使用简洁键值对数组，降低学习门槛。"
    )

    # ── Scale & Progress ──
    pdf.divider()
    pdf.set_font("Kai", "", 15)
    pdf.set_text_color(*pdf.primary)
    pdf.cell(0, 10, "规模与进度")
    pdf.ln(12)

    pdf.body_text(
        "预计 1,200–1,500 有效 MoonBit 代码行，含完整测试与文档。"
        "当前已完成 Lexer、Parser、Renderer、CLI Demo，15 个测试全部通过。"
        "后续计划：增加更多内置 Helper、支持嵌套上下文、发布至 mooncakes.io。"
    )

    # ── Use Cases ──
    pdf.divider()
    pdf.set_font("Kai", "", 15)
    pdf.set_text_color(*pdf.primary)
    pdf.cell(0, 10, "适用场景")
    pdf.ln(12)

    pdf.bullet_list([
        "MoonBit Web 应用服务端渲染（SSR）",
        "静态站点生成器模板引擎",
        "HTML 邮件模板生成",
        "结合 MoonMarkdown 形成完整文档工具链",
    ])

    pdf.output("docs/competition/MoonTemplate项目申报书.pdf")
    print("Done: docs/competition/MoonTemplate项目申报书.pdf")


if __name__ == "__main__":
    build()
