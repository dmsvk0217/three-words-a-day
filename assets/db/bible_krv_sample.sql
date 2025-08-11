-- 책 정보
CREATE TABLE books (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  abbr TEXT NOT NULL
);

INSERT INTO books (id, name, abbr) VALUES
(1, '창세기', '창'),
(2, '출애굽기', '출');

-- 절 정보
CREATE TABLE verses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  book_id INTEGER NOT NULL,
  chapter INTEGER NOT NULL,
  verse INTEGER NOT NULL,
  text TEXT NOT NULL,
  UNIQUE(book_id, chapter, verse),
  FOREIGN KEY(book_id) REFERENCES books(id)
);

-- 창세기 1장
INSERT INTO verses (book_id, chapter, verse, text) VALUES
(1, 1, 1, '태초에 하나님이 천지를 창조하시니라'),
(1, 1, 2, '땅이 혼돈하고 공허하며 흑암이 깊음 위에 있고 하나님의 신은 수면 위에 운행하시니라'),
(1, 1, 3, '하나님이 가라사대 빛이 있으라 하시매 빛이 있었고');

-- 창세기 2장
INSERT INTO verses (book_id, chapter, verse, text) VALUES
(1, 2, 1, '천지와 만물이 다 이루어지니라'),
(1, 2, 2, '하나님이 그 하시던 일을 일곱째 날에 마치시니 그 하시던 모든 일을 그치고 일곱째 날에 안식하시니라');

-- 출애굽기 1장
INSERT INTO verses (book_id, chapter, verse, text) VALUES
(2, 1, 1, '야곱과 함께 각기 가족을 데리고 애굽에 이른 이스라엘 아들들의 이름은 이러하니'),
(2, 1, 2, '르우벤과 시므온과 레위와 유다와');
