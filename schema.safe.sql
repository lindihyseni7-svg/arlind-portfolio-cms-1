USE defaultdb;

CREATE TABLE IF NOT EXISTS profile_settings (
    id INT NOT NULL PRIMARY KEY,
    full_name VARCHAR(140) NOT NULL,
    title VARCHAR(180) NOT NULL,
    bio TEXT NOT NULL,
    philosophy TEXT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    age INT NOT NULL,
    location VARCHAR(140) NOT NULL,
    email VARCHAR(180) NOT NULL,
    password VARCHAR(180) NOT NULL
);

CREATE TABLE IF NOT EXISTS skills (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    skill_name VARCHAR(120) NOT NULL,
    category VARCHAR(120) NOT NULL
);

CREATE TABLE IF NOT EXISTS projects (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    stack VARCHAR(180) NOT NULL
);

CREATE TABLE IF NOT EXISTS messages (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    sender_name VARCHAR(140) NOT NULL,
    email VARCHAR(180) NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO profile_settings (
    id, full_name, title, bio, philosophy, image_url, age, location, email, password
)
SELECT
    1,
    'Arlind Hyseni',
    'Full-Stack Software Engineer',
    'Ndertoj produkte moderne me Java, API te pastra dhe databaza reale MySQL.',
    'Programimi nuk eshte thjesht kodim; eshte arkitektura e se ardhmes. Si student 19-vjecar ne FSHMN dhe zhvillues i apasionuar, une besoj se inovacioni lind aty ku matematika takon imagjinaten. Cdo projekt qe ndertoj eshte nje perpjekje per te thjeshtuar kompleksitetin.',
    'https://ui-avatars.com/api/?name=Arlind+Hyseni&background=0f172a&color=06b6d4&size=280',
    19,
    'Kosove',
    'arlind@example.com',
    'admin123'
WHERE NOT EXISTS (
    SELECT 1 FROM profile_settings WHERE id = 1
);

INSERT INTO skills (skill_name, category)
SELECT 'HTML', 'Frontend'
WHERE NOT EXISTS (SELECT 1 FROM skills WHERE skill_name = 'HTML');

INSERT INTO skills (skill_name, category)
SELECT 'CSS', 'Frontend'
WHERE NOT EXISTS (SELECT 1 FROM skills WHERE skill_name = 'CSS');

INSERT INTO skills (skill_name, category)
SELECT 'JavaScript', 'Frontend'
WHERE NOT EXISTS (SELECT 1 FROM skills WHERE skill_name = 'JavaScript');

INSERT INTO skills (skill_name, category)
SELECT 'Bootstrap', 'Frontend'
WHERE NOT EXISTS (SELECT 1 FROM skills WHERE skill_name = 'Bootstrap');

INSERT INTO skills (skill_name, category)
SELECT 'GitHub', 'Tools'
WHERE NOT EXISTS (SELECT 1 FROM skills WHERE skill_name = 'GitHub');

INSERT INTO skills (skill_name, category)
SELECT 'Java', 'Backend'
WHERE NOT EXISTS (SELECT 1 FROM skills WHERE skill_name = 'Java');

INSERT INTO skills (skill_name, category)
SELECT 'PHP', 'Backend'
WHERE NOT EXISTS (SELECT 1 FROM skills WHERE skill_name = 'PHP');

INSERT INTO skills (skill_name, category)
SELECT 'MySQL (Advanced)', 'Database'
WHERE NOT EXISTS (SELECT 1 FROM skills WHERE skill_name = 'MySQL (Advanced)');

INSERT INTO projects (title, description, stack)
SELECT 'Portfolio Personal', 'CMS personal me Java, admin dashboard, login, settings dinamike dhe public site me dark neon design.', 'Java, MySQL, HTML, CSS, JavaScript'
WHERE NOT EXISTS (SELECT 1 FROM projects WHERE title = 'Portfolio Personal');

INSERT INTO projects (title, description, stack)
SELECT 'Menaxhim Studentor', 'Sistem i konceptuar per ruajtjen e studenteve, lendeve dhe notave me backend te organizuar.', 'Java, SQL'
WHERE NOT EXISTS (SELECT 1 FROM projects WHERE title = 'Menaxhim Studentor');

INSERT INTO projects (title, description, stack)
SELECT 'Kontakt Form API', 'Formular kontakti qe ruan mesazhet ne databaze dhe i shfaq ne panelin admin.', 'Java, REST, MySQL'
WHERE NOT EXISTS (SELECT 1 FROM projects WHERE title = 'Kontakt Form API');
