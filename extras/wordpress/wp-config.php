<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'root');

/** MySQL database password */
define('DB_PASSWORD', '');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '.%$TSH<.*sbx)*V6O|$/aJI;L$u3Vod5-I0o!YJ}fWCN6s?[[-eg5++[<TQi@i@$');
define('SECURE_AUTH_KEY',  'TN=gq3BuO4SB-GtGYB?q::;(5Kl%ztb H52F#p8K|O?A*Q+CpQ7L Px+%D2~k0xp');
define('LOGGED_IN_KEY',    '0.~@c k-k^fx&@^j&1FIvpp7+c2<x^+4IB(9d.~7o@_15d^5U2Q6g8`<QaEo(2?8');
define('NONCE_KEY',        '[3k:5x*iu.#|]o9N?VN/L].5S9`xzP7^K@wOc~iF-Je.`AyCs+Q].uW0>|ss]M+:');
define('AUTH_SALT',        'CHuyihX$}OM]x04qk-B_!`/t+<-)|fR,,-&@6h|80I_YP6jLpgF]9b#PlG|kJpZO');
define('SECURE_AUTH_SALT', '|B_GGy,Y$4dw@UQckp2fCEaV>;lWiqRuuOw;?ZAT<l&z%p%W8O@/SC0HW,Bl a>~');
define('LOGGED_IN_SALT',   'A,X$#5Pw;N/-y@d4Z+5L8!9Wnp(L-2^]e{kE#7/N`[GZX{;fTWEoe.8sjM5~D|cU');
define('NONCE_SALT',       '2(Wr*M$bmHjdl><c@TG8P3bo[[`{To3L0=8jtGZ?LWdohV(9X%]K}F@{|q7@djx4');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', '');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
