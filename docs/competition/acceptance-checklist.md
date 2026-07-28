# 验收清单

## 代码交付

- [x] 项目以 MoonBit 为主要实现语言
- [x] GitHub 和 GitLink 仓库公开可访问
- [x] 提交记录清晰，功能扩展和修复均有独立提交
- [x] 源代码结构清晰，能够完成声明的核心功能
- [x] README 说明项目目标、安装方式、使用方法和示例，可复现
- [x] CI 覆盖 `moon check`、格式门禁、`moon info` 接口门禁和 `moon test`

## 核心功能

- [x] 变量插值：{{ name }}，自动 HTML 转义
- [x] 非转义输出：{{{ html }}}，用于可信任内容
- [x] 条件渲染：{{#if condition}}...{{/if}}
- [x] If/Else 分支：{{#if condition}}...{{else}}...{{/if}}
- [x] 循环遍历：{{#each items}}...{{/each}}
- [x] Unless、注释、Partial、Helper 和错误诊断
- [x] 编译复用：compile() + render() API
- [x] CLI 演示工具

## 测试

- [x] 37 个测试覆盖公开 API、HTML 转义、扩展渲染和边界行为
- [x] 所有测试通过
- [x] 编译零错误

## 文档

- [x] README.md（项目目标、安装、使用、示例）
- [x] 开源许可证（MIT）
- [x] 项目申报书（PDF）
- [x] 开发报告
- [x] 验收清单

## 工程质量

- [x] 类型安全（0 编译错误）
- [x] 模块化包结构（6 个包，包含 CLI）
- [x] CI/CD 持续集成
- [x] 零外部依赖
- [x] 可与 MoonMarkdown 协同组成文档工具链

## 发布

- [ ] `jshsj124/moontemplate` 已发布并可在 mooncakes.io 查询
