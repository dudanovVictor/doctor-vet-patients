-- +goose Up
CREATE TABLE IF NOT EXISTS preparation (
    id          BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    dose        FLOAT NOT NULL,
    course      VARCHAR(100) NOT NULL,
    category    VARCHAR(100),
    option      VARCHAR(255)
);
COMMENT ON TABLE preparation IS 'Рекомендованный препарат по симптому';
COMMENT ON COLUMN preparation.id IS 'ID записи';
COMMENT ON COLUMN preparation.name IS 'Название препарата';
COMMENT ON COLUMN preparation.dose IS 'Дозирование препарата';
COMMENT ON COLUMN preparation.course IS 'Курс получения препарата (2 раза в день после еды)';
COMMENT ON COLUMN preparation.category IS 'К какой категории относится препарат(витамин, антибиотик)';
COMMENT ON COLUMN preparation.option IS 'Доп поле для уточнения';

INSERT INTO preparation (name, dose, course, category, option)
VALUES
    ('катозал', 1, 'раз в день', 'витамин', '5 дней'),
    ('цефтриаксон', 1, 'раз в день', 'антитбиотик', '5 дней'),
    ('амоксициллин', 1, 'в 2 дня', 'антитбиотик', '3 раза'),
    ('раствор рингера', 1, 'в день', 'физ. pаствор', '1-2 раза по необходимости');

CREATE TABLE IF NOT EXISTS symptom (
    id    BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name  VARCHAR(255)
);
COMMENT ON TABLE symptom IS 'Симптомы';
COMMENT ON COLUMN symptom.id IS 'ID записи';
COMMENT ON COLUMN symptom.name IS 'Название записи';

INSERT INTO symptom (name)
VALUES
    ('анемия'),
    ('анорексия'),
    ('обезвоживание'),
    ('диарея с кровью'),
    ('диарея без крови'),
    ('рвота c желчью'),
    ('рвота с кровью'),
    ('рвота без крови'),
    ('высокая температура до 40'),
    ('высокая температура выше 40'),
    ('алопеции единичная'),
    ('алопеции множественная'),
    ('открытая рана гнойная'),
    ('открытая рана условно чистая'),
    ('постоперационая рана воспаленная'),
    ('постоперационая рана условно чистая'),
    ('воспаление в ротовой полости'),
    ('зуд воспаление, выпадение шерсти'),
    ('увеличенные почки'),
    ('кашель'),
    ('гипоксия'),
    ('выделения из глаз гнойные'),
    ('выделения из глаз прозрачные');

CREATE TABLE IF NOT EXISTS symptom_relation_preparation (
    id                              BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    symptom_id                      BIGINT REFERENCES symptom(id) ON DELETE CASCADE,
    preparation_id                  BIGINT REFERENCES preparation(id) ON DELETE CASCADE,
    option                          jsonb
);
COMMENT ON TABLE symptom_relation_preparation IS 'Связи симптомов с препаратами';
COMMENT ON COLUMN symptom_relation_preparation.id IS 'ID записи';
COMMENT ON COLUMN symptom_relation_preparation.preparation_id IS 'ID препарата';
COMMENT ON COLUMN symptom_relation_preparation.symptom_id IS 'ID симптома';
COMMENT ON COLUMN symptom_relation_preparation.option IS 'Возможные доп поля';

CREATE TABLE IF NOT EXISTS preliminary_diagnosis (
    id          BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name        text NOT NULL,
    option      jsonb
);
COMMENT ON TABLE preliminary_diagnosis IS 'Предварительный диагноз';
COMMENT ON COLUMN preliminary_diagnosis.id IS 'ID записи';
COMMENT ON COLUMN preliminary_diagnosis.name IS 'Название записи';
COMMENT ON COLUMN preliminary_diagnosis.option IS 'Возможные доп анализы (анализ крови, узи, бак посев)';

CREATE TABLE IF NOT EXISTS symptom_relation_preliminary_diagnosis (
    id                              BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    symptom_id                      BIGINT REFERENCES symptom(id) ON DELETE CASCADE,
    preliminary_diagnosis_id        BIGINT REFERENCES preliminary_diagnosis(id) ON DELETE CASCADE,
    option                          jsonb
);
COMMENT ON TABLE symptom_relation_preliminary_diagnosis IS 'Связи симптомов с предварительным диагнозом';
COMMENT ON COLUMN symptom_relation_preliminary_diagnosis.id IS 'ID записи';
COMMENT ON COLUMN symptom_relation_preliminary_diagnosis.symptom_id IS 'ID препарата';
COMMENT ON COLUMN symptom_relation_preliminary_diagnosis.preliminary_diagnosis_id IS 'ID предварительного диагноза';
COMMENT ON COLUMN symptom_relation_preliminary_diagnosis.option IS 'Возможные доп поля';



CREATE TABLE IF NOT EXISTS reference (
    id    BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name  VARCHAR(255),
    type  VARCHAR(30)
);
COMMENT ON TABLE reference IS 'Справочник';
COMMENT ON COLUMN reference.id IS 'ID записи';
COMMENT ON COLUMN reference.name IS 'Название записи';
COMMENT ON COLUMN reference.type IS 'Тип справочник (animal, breed)';


CREATE INDEX idx_symptom_prelim_diag  ON symptom_relation_preliminary_diagnosis USING btree(symptom_id, preliminary_diagnosis_id);
CREATE INDEX idx_symptom_preparation ON symptom_relation_preparation USING btree(symptom_id, preparation_id);


-- +goose Down
DROP TABLE IF EXISTS reference;
DROP TABLE IF EXISTS preparation;
DROP TABLE IF EXISTS preliminary_diagnosis;
DROP TABLE IF EXISTS symptom;
DROP TABLE IF EXISTS symptom_relation_preparation;
DROP TABLE IF EXISTS symptom_relation_preliminary_diagnosis;
DROP INDEX IF EXISTS idx_symptom_prelim_diag;
DROP INDEX IF EXISTS idx_symptom_preparation;

