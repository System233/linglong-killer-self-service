# Linglong Killer Self-Service (ll-killer 玲珑杀手)

## 项目简介
Linglong Killer Self-Service（简称 **ll-killer**）是一款面向玲珑社区的自动打包工具。玲珑环境中存在路径管理等复杂问题，本项目通过嵌套命名空间技术突破了这些限制，实现了对任意软件的一键apt安装，并支持嵌套环境的重入。结合 GitHub Actions，用户只需在 Issue 区按照指定格式提交请求，系统即可根据提供的信息生成对应的软件包并提供下载链接。此工具旨在简化软件包构建流程，提高开发效率，**尤其**适用于玲珑平台的用户。

## 功能特点
- **一键打包：** 自动处理路径问题、图标、桌面文件等，用户无需手动调整。
- **自助服务：** 通过提交模板化 Issue，用户能够快速启动构建流程。
- **自动化构建：** 依托 GitHub Actions 完成软件包构建与发布，省去手动操作。
- **兼容性强：** `ll-killer` 重塑了玲珑容器文件布局，确保 `deb` 包开箱即用，无需额外的 `hack` 处理。
- **动态生成：** 除必要字段外，其他信息由系统自动推断或生成，减少用户的工作量。

## 使用指南
### 1. 提交构建请求
在 GitHub 的 [Issue](https://github.com/System233/linglong-killer-self-service/issues/new?template=%E8%87%AA%E5%8A%A9%E6%9E%84%E5%BB%BA.md) 区发起新 Issue，选择自助构建模板，按照以下格式填写内容：

```package
Package: 软件包名称
Name: 应用显示名称（可选）
Version: 软件版本号（可选，默认最新）
Base: 构建基础环境（可选）
Runtime: 构建 Runtime 环境（可选，不建议使用）
Depends: 依赖包列表（可选）
APT-Sources: sources.list 格式的 APT 仓库定义，请使用 [trusted=yes] 忽略签名，支持多个源（可选，支持多行）
Description: 软件描述信息（可选，支持多行）
```

* 只需提供 `Package` 和 `APT-Sources`，其他字段将由系统自动生成。
* 多行内容需确保行首有普通空格。
* 可以通过运行 `apt-cache show "deb包名"` 来查看软件包的详细信息。
* 如需调整构建参数，请直接编辑issue并保存.

### 2. 构建参数说明
以下是模板中各字段的详细说明：

| 字段            | 是否必须 | 说明                                                                           |
| --------------- | -------- | ------------------------------------------------------------------------------ |
| **Package**     | 是       | `deb` 包名，必须存在于 APT 仓库中。                                            |
| **Name**        | 否       | 应用的显示名称，默认为软件包名称。                                             |
| **Version**     | 否       | `deb` 包版本号，默认为最新版本。                                               |
| **Base**        | 否       | 玲珑容器 Base，默认为 `org.deepin.base/23.1.0`。                               |
| **Runtime**     | 否       | 玲珑容器 Runtime，通常不建议使用此选项。                                       |
| **Depends**     | 否       | 软件包可选依赖列表，以逗号或空格分隔，包含可选插件的依赖。                     |
| **APT-Sources** | 否       | 构建过程中使用的 APT 软件源地址，支持多个源，请使用 `[trusted=yes]` 忽略签名。 |
| **Description** | 否       | 软件包描述信息，支持多行内容，行首需有普通空格。                               |

#### 2.1 已知的 Base 示例
- `org.deepin.base/23.1.0`
- `org.deepin.foundation/20.0.0`
- `org.deepin.foundation/23.0.0`
- `com.uniontech.foundation/20.0.1`

#### 2.2 示例应用配置：
- [GIMP 示例配置](tests/gimp.md)

### 3. 构建流程
- 提交 Issue 后，系统会自动触发构建流程。
- 构建完成后，系统会在对应 Issue 中回复软件包的下载链接和构建日志。


### 4. 注意事项
- **Package 字段必须提供：** 请确保 `Package` 是有效的 deb 包名，且存在于指定的 APT 仓库中。
- **二进制兼容性：** 请确保 `Base` 与指定的 deb 软件包兼容，特别是 `libc`，如果不兼容，请调整 `Base` 为合适的版本。
- **遵循模板格式：** 所有字段需按模板格式填写，否则可能导致构建失败。
- **依赖性字段：** 如果 `Depends` 字段未填写，系统会尽可能自动检测，但某些情况下可能需要用户手动补充。

## 贡献指南
欢迎为项目贡献代码或建议！您可以通过以下方式参与：
- 提交 Pull Request 修复 Bug 或添加新功能。
- 提交 Issue 提出您的改进建议。
- 提供更多模板样例，提升系统的兼容性。

## 技术栈
- **GitHub Actions:** 用于实现自动化工作流。
- **BASH:** 实现构建时的核心逻辑和脚本处理。
- **Go:** 实现运行时的核心逻辑和脚本处理。
- **YAML:** 配置 GitHub Actions 的工作流文件。

特别感谢 **ChatGPT** 在项目文档编写中的帮助，提供了简洁明了的说明和技术支持，使得文档的内容更加完善。

## 许可证
本项目基于 [MIT License](LICENSE) 开源，欢迎自由使用与修改。
