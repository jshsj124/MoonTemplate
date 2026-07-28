# MoonTemplate 项目申报书

## 基本信息

| 项目 | 内容 |
|------|------|
| **项目名称** | MoonTemplate：Handlebars 风格模板引擎的 MoonBit 移植 |
| **GitHub 仓库** | https://github.com/jshsj124/MoonTemplate |
| **GitLink 仓库** | https://gitlink.org.cn/JshsJ/moontemplate |
| **项目方向** | MoonBit 基础库 / Web 开发基础设施 |
| **是否为移植项目** | 是 |
| **许可证** | MIT |

## 项目简介

MoonTemplate 是一个纯 MoonBit 实现的 Handlebars 风格模板引擎，将模板字符串与上下文数据结合，生成标准 HTML 输出。项目面向需要在 MoonBit 中进行服务端渲染、静态站点生成或 HTML 邮件模板开发的开发者，提供变量插值、条件渲染、循环遍历和自动 HTML 转义等核心模板功能。

MoonBit 生态中目前缺乏模板引擎，Web 开发场景中的 HTML 生成依赖于动拼接，缺乏结构化、安全的模板方案。本项目填补这一空白。

## 核心功能范围

- 变量插值：`{{ name }}`，自动 HTML 转义防止 XSS
- 非转义输出：`{{{ html }}}`，用于信任的 HTML 内容
- 条件渲染：`{{#if condition}}...{{/if}}`，支持 `{{else}}` 分支
- 反向条件：`{{#unless condition}}...{{/unless}}`
- 循环遍历：`{{#each items}}...{{/each}}`，支持逗号分隔的集合
- 注释、Partial 与 Helper 扩展能力
- 富上下文值、模板错误位置和格式化诊断
- 编译后复用：`compile` 预编译模板，`render` 多次渲染不同上下文
- CLI 演示工具
- 零外部依赖，纯 MoonBit 实现

## 移植或参考说明

原项目名称：Handlebars.js

原项目链接：https://github.com/handlebars-lang/handlebars.js

原项目许可证：MIT

本项目许可证：MIT

与原项目相比，本项目做了以下简化和重新设计：

- 使用 MoonBit 原生类型系统和包结构组织代码；
- 保留简洁键值对入口，同时提供富上下文值、Partial 和 Helper 扩展类型；
- API 与 Handlebars.js 不追求一一对应，按 MoonBit 类型系统重新设计；
- 循环中的集合以逗号分隔字符串表示，简化数据传递。

## 项目规模

当前跟踪 1,133 行 MoonBit 源码，覆盖核心实现、CLI 和测试套件；项目保持零外部运行时依赖。

## 实现进度

- 已完成：Lexer、Parser、Renderer、CLI Demo、HTML 安全转义、unless、注释、Partial、Helper、富上下文和错误诊断
- 质量状态：`moon check --deny-warn`、格式门禁、接口门禁和 37 个测试全部通过

## 适用场景

- MoonBit Web 应用服务端渲染
- 静态站点生成器模板引擎
- HTML 邮件模板生成
- 文档自动化生成工具
- 结合 MoonMarkdown 形成完整文档工具链
