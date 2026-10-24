# house-style — thiết kế

Ngày: 2026-10-23 · Chủ: jarviisha

## Ý định

jarviisha làm việc liên tục trên `jarviisha/onehand`, `jarviisha/docdoc`,
`jarviisha/darkvoid`, `jarviisha/codohue` và `taoworklabs/mmerp`. Commit, PR,
tên nhánh, file CI/CD, release và tài liệu ở mỗi repo một kiểu. Mục tiêu: một
"hình hài" cá nhân, đơn giản, lặp lại giống nhau ở mọi repo — nhảy giữa các
repo không phải nghĩ "repo này làm kiểu gì".

Phần lớn commit/PR do agent (Claude Code, và agent trong onehand) viết, nên
quy ước phải nằm ở chỗ agent đọc được.

## Hiện trạng (khảo sát 2026-10-23 bằng `gh`)

| | onehand | docdoc | darkvoid | codohue | mmerp |
|---|---|---|---|---|---|
| Merge cho phép | squash | squash (có 1 merge commit #29) | merge + squash + rebase | squash | squash |
| Squash title / message | PR_TITLE / PR_BODY | PR_TITLE / PR_BODY | COMMIT_OR_PR_TITLE / COMMIT_MESSAGES | PR_TITLE / PR_BODY | PR_TITLE / PR_BODY |
| Xoá nhánh khi merge | có | không | không | không | có |
| Nhánh | `type/…` | `001-…`→`029-…`, `feat/…` | `type/…`, `onehand/issue-…` | `type/…`, `onehand/issue-…` | `type/…`, `approval-flows` |
| Workflows | ci, release | ci | ci, cd, bot-schema-retirement | build, ci, deploy | ci, ui |
| Tag / Release | v0.1.0 pre-release | không | tag v0.1.0, không release | v0.6.0–v0.12.1, tên release không đều | không |
| CHANGELOG.md | có | có | không | có | không |
| AGENTS.md / CLAUDE.md | cả hai | AGENTS | cả hai | cả hai | CLAUDE (+ ~10 file .md ở gốc) |

Commit message đã gần thống nhất: conventional commits `type(scope): …`.

## Mục tiêu

1. Một repo `jarviisha/house-style` (public, thư mục `~/development/house-style`)
   chứa toàn bộ quy ước, phát hành dưới dạng **plugin Claude Code** (repo tự là
   marketplace) để cài một lần, sửa một chỗ.
2. Một **skill** dạy agent viết commit, mô tả PR, đặt tên nhánh, ra release,
   sắp tài liệu theo house style.
3. Một **script** áp cấu hình GitHub lên danh sách repo, chạy lại bao nhiêu lần
   cũng ra cùng kết quả.
4. Đưa 5 repo về đúng house style (cấu hình + đổi tên file + tài liệu), mỗi
   repo một PR.

## Không làm

- Không ép quy ước bằng CI (commitlint, hook chặn push…). Quy ước là hướng dẫn
  cho agent và cấu hình GitHub, không phải cổng chặn.
- Không dùng release-please, semantic-release, git-cliff hay bot nào.
- Không PR template, issue template, label.
- Không viết lại lịch sử git, không đổi tên/xoá tag cũ.

## Phản mục tiêu (làm vậy là hỏng dù "chạy được")

- Có nhiều bản sao quy ước có thể lệch nhau (vd chép skill vào từng repo).
- Thân commit trong `git log` đầy `##`, emoji, link markdown, dòng `-----`.
- Bắt agent làm việc thừa khi chưa ai cần (vd cập nhật `Unreleased` mỗi PR ở
  repo chưa từng release).

## Quy ước (đã chốt)

### Merge & commit

- **Chỉ squash merge.** Tắt merge commit và rebase merge.
- Cấu hình squash: title = `PR_TITLE`, message = `PR_BODY`. **Giữ thân commit**
  (jarviisha chọn) — nên mô tả PR phải đọc được cả trên web lẫn terminal.
- Tự xoá nhánh sau khi merge.
- Tiêu đề PR = tiêu đề commit squash: `type(scope): mô tả ngắn`, GitHub tự thêm
  ` (#N)`. Ngắn như mmerp (ví dụ jarviisha thích:
  `refactor(platform): squash every migration into one baseline (#131)`).
- `type`: `feat fix refactor perf docs test build ci chore style`. `!` cho thay
  đổi phá tương thích (`feat!: …`). scope tuỳ chọn.
- Commit thẳng lên main: cùng dạng tiêu đề; thân dài tuỳ ý, plain text.

### Mô tả PR (= thân commit squash)

- Plain text: đoạn văn ngắn + gạch đầu dòng `-`. Không heading `##`, không
  bảng, không emoji, không dòng `🤖 Generated with …`.
- Backtick cho tên file/lệnh được (đọc ổn ở cả hai nơi).
- Không tự ngắt dòng giữa câu; một ý một dòng.
- Trailer `Co-authored-by:` giữ nếu có.
- Ví dụ:

  ```
  Squash the 44 migrations into one baseline.

  - 0001–0044 become 20261023000000_all_baseline.sql
  - pg_dump of a fresh and an old database are identical
  - existing dev databases need make reset-db

  Builds on #130.
  ```

### Ngôn ngữ

- Mọi thứ agent viết vào repo bằng **tiếng Anh**: commit, tiêu đề và mô tả PR,
  tên nhánh, CHANGELOG, release, `AGENTS.md`, skill (jarviisha chọn).

### Nhánh

- `type/slug-ngan` với `type` cùng bộ ở trên (`feat/console-shadcn`).
- Nhánh agent onehand tạo (`onehand/issue-N-…`) là ngoại lệ được chấp nhận.
- Bỏ kiểu đánh số `001-…`. Không bắt buộc số issue.

### CI/CD — tên file trong `.github/workflows/`

- `ci.yml` — lint, test, build; chạy trên PR và push vào main. Mọi repo có.
- `release.yml` — chạy khi push tag `v*`; build artifact/image, tạo GitHub
  Release. Chỉ có khi repo đã release.
- `deploy.yml` — chỉ repo thật sự deploy.
- Workflow đặc thù khác: đặt tên theo việc nó làm.

### Release

Quy tắc duy nhất: **có tag `v*` thì có Release và CHANGELOG; chưa có thì chưa
có gì.** Skill nhìn tag để biết repo đang ở trạng thái nào.

- SemVer, tag `vX.Y.Z`. Thời `0.x`: phá tương thích tăng minor, còn lại patch.
- Tên Release = tag (`v0.12.1`), không thêm chữ.
- Nội dung Release = đúng mục của version đó trong `CHANGELOG.md`.
- `CHANGELOG.md` theo Keep a Changelog: `## [Unreleased]` trên cùng, nhóm
  `Added / Changed / Fixed / Removed`, viết cho người dùng, không chép commit.
- Ra bản: chuyển `Unreleased` thành `## [X.Y.Z] - YYYY-MM-DD`, commit
  `chore(release): vX.Y.Z`, tag, push; `release.yml` tạo Release từ mục đó.
- Repo chưa release: không tag, không `release.yml`, không CHANGELOG, không
  cập nhật `Unreleased`. Release đầu tiên: agent viết CHANGELOG từ `git log`
  bắt đầu ở `[0.1.0]` (hoặc version phù hợp), thêm `release.yml`.
- Repo deploy liên tục (darkvoid) vẫn dùng tag làm mốc deploy, nên đi theo
  luồng release đầy đủ.

### Tài liệu

- `AGENTS.md` là bản chính cho agent. `CLAUDE.md` chỉ chứa `@AGENTS.md`.
- `README.md`: repo là gì, chạy thế nào, link sang `docs/`.
- `docs/`: ADR, thiết kế, mọi thứ còn lại. File `.md` rời ở gốc chuyển vào
  `docs/` (vd mmerp) — hỏi jarviisha trước khi chuyển.

## Hình dạng repo house-style

```
house-style/
  .claude-plugin/marketplace.json   # repo là marketplace
  .claude-plugin/plugin.json        # và là plugin "house-style"
  skills/house-style/SKILL.md       # quy ước + cách làm cho agent
  scripts/apply-github-settings.sh  # gh api, nhận danh sách owner/repo
  repos.txt                         # 5 repo đang áp dụng
  README.md                         # cài plugin, chạy script
  docs/specs/…                      # tài liệu này
```

House-style tự tuân theo house style (squash, `ci.yml` nếu có, v.v.).

Cài: `/plugin marketplace add jarviisha/house-style` rồi
`/plugin install house-style@house-style`, ở phạm vi user (một lần mỗi máy).
Agent trong onehand chạy trên máy jarviisha nên cũng thấy plugin này; không
cần khai báo plugin ở `.claude/settings.json` từng repo.
Agent không phải Claude (Codex…) đọc quy ước qua một dòng trong `AGENTS.md` mỗi
repo trỏ tới `https://github.com/jarviisha/house-style` — tóm tắt 5–10 dòng
quy ước cốt lõi ngay trong `AGENTS.md` là được, chi tiết ở skill.

## Đưa 5 repo về house style

Mỗi repo một nhánh `chore/adopt-house-style` từ main mới nhất và một PR
`chore: adopt house style` do agent push và mở (jarviisha cho phép, kể cả
taoworklabs/mmerp); jarviisha tự merge. Không force-push, không commit thẳng
main. PR gồm những gì áp dụng được:

- Mục `## House style` trong `AGENTS.md` (nội dung dưới đây, `#N` = số PR này).
  Dòng cuối là quan trọng nhất: agent hay bắt chước `git log`, nên phải nói
  rõ lịch sử cũ không phải mẫu.

  ```markdown
  ## House style

  This repo follows jarviisha/house-style (https://github.com/jarviisha/house-style),
  adopted on 2026-10-24 in #N. Claude: use the house-style skill.

  - Squash merge only. PR title = commit title: `type(scope): summary`.
  - PR body is plain text: short paragraphs and `-` bullets, no `##` headings,
    no emoji, no "Generated with" line. It becomes the squash commit body.
  - Branches: `type/short-slug`.
  - Workflows: ci.yml, release.yml, deploy.yml.
  - Releases: tag vX.Y.Z, release title = tag, body = CHANGELOG section.
  - Everything in English.

  History before 2026-10-24 does not follow these rules. Do not copy the style
  of older commits, PR bodies, branches or releases, and do not rewrite or
  rename them.
  ```

- Đổi tên/gộp workflow: darkvoid `cd.yml`→`deploy.yml`; codohue `build.yml`
  gộp vào `release.yml` nếu nó build theo tag (đọc nội dung trước); mmerp
  `ui.yml` gộp vào `ci.yml` nếu hợp lý. Sửa mọi chỗ tham chiếu tên cũ (badge,
  docs, required status checks).
- `CLAUDE.md` → `@AGENTS.md`, chuyển nội dung sang `AGENTS.md` (mmerp,
  docdoc thiếu một trong hai).
- CHANGELOG: docdoc có CHANGELOG nhưng chưa release — xem nội dung rồi đề xuất
  giữ/bỏ với jarviisha. darkvoid có tag v0.1.0 nên đã ở trạng thái "đã
  release" (quyết định của người viết): PR thêm `CHANGELOG.md` với
  `## [Unreleased]` và một dòng `## [0.1.0]` không viết bù chi tiết, thêm
  `release.yml`; `cd.yml`→`deploy.yml` chỉ đổi tên, giữ nguyên trigger.
- onehand có tag v0.1.0 (pre-release) → cũng là "đã release", đi luồng đầy đủ.
- Release cũ (tên không đều ở codohue, pre-release ở onehand) giữ nguyên, không
  sửa — quy ước áp dụng từ bản kế tiếp (quyết định của người viết).
- Cấu hình GitHub: chạy script cho cả 5 repo.
- Nhánh cũ đã merge (docdoc, codohue, darkvoid): liệt kê, xin xác nhận rồi mới
  xoá. Không xoá nhánh chưa merge.

## Để cho người xây quyết

- Lời văn và cấu trúc cụ thể của `SKILL.md` (viết tiếng Anh cho agent).
- Chi tiết script (bash + `gh api`), cách in kết quả.
- Nội dung `release.yml` từng repo (trích mục CHANGELOG bằng awk/sed là đủ).
- Thứ tự áp 5 repo.

## Cần xác nhận với jarviisha khi làm

- Chuyển các file `.md` ở gốc mmerp vào `docs/`.
- ~~Giữ/bỏ CHANGELOG hiện có của docdoc.~~ Giữ và tiếp tục cập nhật trước bản release đầu tiên (jarviisha chọn, 2026-10-24). Quy tắc chung: repo chưa có tag mà đã có CHANGELOG đang được cập nhật thì cứ tiếp tục.
- Danh sách nhánh cũ sẽ xoá.
- Mọi thao tác push/PR/đổi cấu hình trên repo taoworklabs (repo tổ chức).
