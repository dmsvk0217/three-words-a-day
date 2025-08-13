-- 성경 책
CREATE TABLE IF NOT EXISTS books (
  id INTEGER PRIMARY KEY,         -- 1..66
  name TEXT NOT NULL,             -- "창세기"
  abbr TEXT NOT NULL              -- "창"
);

-- 장(옵션: 캐싱용. 없어도 verse의 (book_id, chapter)로 조회 가능)
CREATE TABLE IF NOT EXISTS chapters (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  book_id INTEGER NOT NULL,
  chapter INTEGER NOT NULL,
  verse_count INTEGER NOT NULL,
  UNIQUE(book_id, chapter),
  FOREIGN KEY(book_id) REFERENCES books(id)
);

-- 절 (핵심)
CREATE TABLE IF NOT EXISTS verses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  book_id INTEGER NOT NULL,
  chapter INTEGER NOT NULL,
  verse INTEGER NOT NULL,
  text TEXT NOT NULL,
  UNIQUE(book_id, chapter, verse),
  FOREIGN KEY(book_id) REFERENCES books(id)
);

-- 빠른 탐색용 인덱스
CREATE INDEX idx_verses_ref ON verses(book_id, chapter, verse);

-- 스크랩
CREATE TABLE IF NOT EXISTS scraps (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  book_id INTEGER NOT NULL,
  chapter INTEGER NOT NULL,
  verse INTEGER NOT NULL,
  note TEXT,
  created_at INTEGER NOT NULL DEFAULT (strftime('%s','now')),
  UNIQUE(book_id, chapter, verse)
);

-- 알림 시간(최대 3개)
CREATE TABLE IF NOT EXISTS notification_times (
  id INTEGER PRIMARY KEY CHECK(id IN (1,2,3)),  -- 1~3 고정 슬롯
  hour INTEGER NOT NULL CHECK(hour BETWEEN 0 AND 23),
  minute INTEGER NOT NULL CHECK(minute BETWEEN 0 AND 59),
  enabled INTEGER NOT NULL DEFAULT 1            -- 0/1
);
