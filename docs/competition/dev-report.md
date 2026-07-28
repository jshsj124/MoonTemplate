# MoonTemplate 开发报告

## 项目概述

MoonTemplate 是一个纯 MoonBit 实现的 Handlebars 风格模板引擎。项目目标是为 MoonBit 生态提供一个安全、易用的 HTML 模板渲染方案，支持变量插值、条件渲染和循环遍历等核心模板功能。

参考项目：Handlebars.js（MIT 许可证）。本项目使用 MoonBit 原生类型系统重新设计，优先实现核心功能。

## 开发过程

### 阶段一：类型和架构设计

- 设计 Token 类型（Text / Var / Unescaped / Open / Close）
- 设计 AST Node 类型（Root / Text / Var / Unescaped / If / IfElse / Each）
- 采用经典的 Lexer → Parser → Renderer 三阶段架构
- 上下文使用 `Array[(String, String)]` 简化数据传递

### 阶段二：词法分析器

- 实现 `{{ }}` 和 `{{{ }}}` 分隔符识别
- 支持 `{{#cmd arg}}` 块开标记
- 支持 `{{/cmd}}` 块闭标记
- 支持 `{{else}}` 特殊标记
- 处理标记内空白字符规范化

### 阶段三：语法解析器

- 基于 `parse_until` 函数的递归下降解析
- 处理块嵌套（if 内含 each）
- else 分支的停止条件处理
- 未知块的容错跳过

### 阶段四：渲染器

- 变量查找和 HTML 自动转义
- 非转义输出（{{{ }}} 三括号语法）
- 条件渲染：falsy 值跳过、else 分支
- 循环遍历：逗号分隔集合、上下文作用域隔离
- 自定义 HTML 转义函数（`&`、`<`、`>`、双引号、单引号和反引号）
- Partial 查找、Helper 调用和增强渲染入口
- 富上下文值与带行列信息的模板错误诊断

### 阶段五：CLI 和文档

- CLI 演示程序
- 完整的 README 文档
- 项目申报书和 PDF 生成

## 技术架构

```
Template String
  → Lexer (字符扫描、{{ }} 识别)
  → Token Stream
  → Parser (递归下降、AST 构建)
  → AST
  → Renderer (上下文查找、HTML 转义)
  → Output String
```

核心设计决策：
- 上下文使用数组而非 Map，简化跨函数传递和复制
- 集合用逗号分隔字符串表达，降低数据模型复杂度
- `this` 关键字在循环中引用当前迭代项
- `else` 作为特殊 Open token 处理（而非 Close），保持块结构清晰

## 遇到的挑战

1. **Map API 兼容性**：初始使用 Map[String, String] 作上下文，但跨模块 Map 操作受限，改为 Array[(String, String)]
2. **else 分支解析**：初始将 else 误判为普通 Var 标记，需要 lexer 增加特殊识别
3. **递归解析停止条件**：parse_until 需要在遇到 Close 或 else 时正确停止，需要仔细处理停止边界
4. **StringView 类型兼容**：与 MoonMarkdown 相同的 trim_start()/trim_end() 陷阱，需要自定义 ltrim/rtrim

## 测试结果

- 完整测试：37 个，全部通过
- 严格编译：`moon check --deny-warn` 通过，0 errors / 0 warnings
- 格式门禁：`moon fmt --check` 通过
- 公共接口：`moon info` 生成结果与仓库快照一致
- CLI 演示：变量、条件、循环和 HTML 安全转义输出正常

## 项目统计

- MoonBit 源码：1,133 行（含核心实现、CLI 和测试）
- 包数量：6 个（根包、types、lexer、parser、render、cmd/main）
- 依赖：零外部运行时依赖

## 后续计划

- 实现文件系统模板加载和模板缓存
- 继续完善嵌套对象路径与集合数据模型
- 增加基准测试、模糊测试和更多错误恢复场景
- 按语义化版本持续维护 mooncakes.io 发布
