<?php
/*
Plugin Name: Twitter Plugin
Plugin URI:  http://bestwebsoft.com/plugin/
Description: Plugin to add a link to the page author to twitter.
Author: BestWebSoft
Version: 2.26
Author URI: http://bestwebsoft.com/
License: GPLv2 or later
*/

/*
	 Copyright 2011  BestWebSoft  ( http://support.bestwebsoft.com )
	
	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License, version 2, as 
	published by the Free Software Foundation.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

// add bws menu
if ( ! function_exists( 'bws_add_menu_render' ) ) {
	function bws_add_menu_render() {
		global $wpdb, $wp_version, $title;
		$active_plugins = get_option('active_plugins');
		$all_plugins = get_plugins();
		$error = '';
		$message = '';
		$bwsmn_form_email = '';

		$array_activate = array();
		$array_install	= array();
		$array_recomend = array();
		$count_activate = $count_install = $count_recomend = 0;
		$array_plugins	= array(
			array( 'captcha\/captcha.php', 'Captcha', 'http://bestwebsoft.com/plugin/captcha-plugin/', 'http://bestwebsoft.com/plugin/captcha-plugin/#download', '/wp-admin/plugin-install.php?tab=search&type=term&s=Captcha+bestwebsoft&plugin-search-input=Search+Plugins', 'admin.php?page=captcha.php' ), 
			array( 'contact-form-plugin\/contact_form.php', 'Contact Form', 'http://bestwebsoft.com/plugin/contact-form/', 'http://bestwebsoft.com/plugin/contact-form/#download', '/wp-admin/plugin-install.php?tab=search&type=term&s=Contact+Form+bestwebsoft&plugin-search-input=Search+Plugins', 'admin.php?page=contact_form.php' ), 
			array( 'facebook-button-plugin\/facebook-button-plugin.php', 'Facebook Like Button Plugin', 'http://bestwebsoft.com/plugin/facebook-like-button-plugin/', 'http://bestwebsoft.com/plugin/facebook-like-button-plugin/#download', '/wp-admin/plugin-install.php?tab=search&type=term&s=Facebook+Like+Button+Plugin+bestwebsoft&plugin-search-input=Search+Plugins', 'admin.php?page=facebook-button-plugin.php' ), 
			array( 'twitter-plugin\/twitter.php', 'Twitter Plugin', 'http://bestwebsoft.com/plugin/twitter-plugin/', 'http://bestwebsoft.com/plugin/twitter-plugin/#download', '/wp-admin/plugin-install.php?tab=search&type=term&s=Twitter+Plugin+bestwebsoft&plugin-search-input=Search+Plugins', 'admin.php?page=twitter.php' ), 
			array( 'portfolio\/portfolio.php', 'Portfolio', 'http://bestwebsoft.com/plugin/portfolio-plugin/', 'http://bestwebsoft.com/plugin/portfolio-plugin/#download', '/wp-admin/plugin-install.php?tab=search&type=term&s=Portfolio+bestwebsoft&plugin-search-input=Search+Plugins', 'admin.php?page=portfolio.php' ),
			array( 'gallery-plugin\/gallery-plugin.php', 'Gallery', 'http://bestwebsoft.com/plugin/gallery-plugin/', 'http://bestwebsoft.com/plugin/gallery-plugin/#download', '/wp-admin/plugin-install.php?tab=search&type=term&s=Gallery+Plugin+bestwebsoft&plugin-search-input=Search+Plugins', 'admin.php?page=gallery-plugin.php' ),
			array( 'adsense-plugin\/adsense-plugin.php', 'Google AdSense Plugin', 'http://bestwebsoft.com/plugin/google-adsense-plugin/', 'http://bestwebsoft.com/plugin/google-adsense-plugin/#download', '/wp-admin/plugin-install.php?tab=search&type=term&s=Adsense+Plugin+bestwebsoft&plugin-search-input=Search+Plugins', 'admin.php?page=adsense-plugin.php' ),
			array( 'custom-search-plugin\/custom-search-plugin.php', 'Custom Search Plugin', 'http://bestwebsoft.com/plugin/custom-search-plugin/', 'http://bestwebsoft.com/plugin/custom-search-plugin/#download', '/wp-admin/plugin-install.php?tab=search&type=term&s=Custom+Search+plugin+bestwebsoft&plugin-search-input=Search+Plugins', 'admin.php?page=custom_search.php' ),
			array( 'quotes-and-tips\/quotes-and-tips.php', 'Quotes and Tips', 'http://bestwebsoft.com/plugin/quotes-and-tips/', 'http://bestwebsoft.com/plugin/quotes-and-tips/#download', '/wp-admin/plugin-install.php?tab=search&type=term&s=Quotes+and+Tips+bestwebsoft&plugin-search-input=Search+Plugins', 'admin.php?page=quotes-and-tips.php' ),
			array( 'google-sitemap-plugin\/google-sitemap-plugin.php', 'Google sitemap plugin', 'http://bestwebsoft.com/plugin/google-sitemap-plugin/', 'http://bestwebsoft.com/plugin/google-sitemap-plugin/#download', '/wp-admin/plugin-install.php?tab=search&type=term&s=Google+sitemap+plugin+bestwebsoft&plugin-search-input=Search+Plugins', 'admin.php?page=google-sitemap-plugin.php' ),
			array( 'updater\/updater.php', 'Updater', 'http://bestwebsoft.com/plugin/updater-plugin/', 'http://bestwebsoft.com/plugin/updater-plugin/#download', '/wp-admin/plugin-install.php?tab=search&s=updater+bestwebsoft&plugin-search-input=Search+Plugins', 'admin.php?page=updater-options' )
		);
		foreach ( $array_plugins as $plugins ) {
			if( 0 < count( preg_grep( "/".$plugins[0]."/", $active_plugins ) ) ) {
				$array_activate[$count_activate]["title"] = $plugins[1];
				$array_activate[$count_activate]["link"] = $plugins[2];
				$array_activate[$count_activate]["href"] = $plugins[3];
				$array_activate[$count_activate]["url"]	= $plugins[5];
				$count_activate++;
			} else if ( array_key_exists(str_replace( "\\", "", $plugins[0]), $all_plugins ) ) {
				$array_install[$count_install]["title"] = $plugins[1];
				$array_install[$count_install]["link"]	= $plugins[2];
				$array_install[$count_install]["href"]	= $plugins[3];
				$count_install++;
			} else {
				$array_recomend[$count_recomend]["title"] = $plugins[1];
				$array_recomend[$count_recomend]["link"] = $plugins[2];
				$array_recomend[$count_recomend]["href"] = $plugins[3];
				$array_recomend[$count_recomend]["slug"] = $plugins[4];
				$count_recomend++;
			}
		}
		$array_activate_pro = array();
		$array_install_pro	= array();
		$array_recomend_pro = array();
		$count_activate_pro = $count_install_pro = $count_recomend_pro = 0;
		$array_plugins_pro	= array(
			array( 'gallery-plugin-pro\/gallery-plugin-pro.php', 'Gallery Pro', 'http://bestwebsoft.com/plugin/gallery-pro/?k=382e5ce7c96a6391f5ffa5e116b37fe0', 'http://bestwebsoft.com/plugin/gallery-pro/?k=382e5ce7c96a6391f5ffa5e116b37fe0#purchase', 'admin.php?page=gallery-plugin-pro.php' ),
			array( 'contact-form-pro\/contact_form_pro.php', 'Contact Form Pro', 'http://bestwebsoft.com/plugin/contact-form-pro/?k=773dc97bb3551975db0e32edca1a6d71', 'http://bestwebsoft.com/plugin/contact-form-pro/?k=773dc97bb3551975db0e32edca1a6d71#purchase', 'admin.php?page=contact_form_pro.php' )
		);
		foreach ( $array_plugins_pro as $plugins ) {
			if( 0 < count( preg_grep( "/".$plugins[0]."/", $active_plugins ) ) ) {
				$array_activate_pro[$count_activate_pro]["title"] = $plugins[1];
				$array_activate_pro[$count_activate_pro]["link"] = $plugins[2];
				$array_activate_pro[$count_activate_pro]["href"] = $plugins[3];
				$array_activate_pro[$count_activate_pro]["url"]	= $plugins[4];
				$count_activate_pro++;
			} else if( array_key_exists(str_replace( "\\", "", $plugins[0]), $all_plugins ) ) {
				$array_install_pro[$count_install_pro]["title"] = $plugins[1];
				$array_install_pro[$count_install_pro]["link"]	= $plugins[2];
				$array_install_pro[$count_install_pro]["href"]	= $plugins[3];
				$count_install_pro++;
			} else {
				$array_recomend_pro[$count_recomend_pro]["title"] = $plugins[1];
				$array_recomend_pro[$count_recomend_pro]["link"] = $plugins[2];
				$array_recomend_pro[$count_recomend_pro]["href"] = $plugins[3];
				$count_recomend_pro++;
			}
		}
		
		$sql_version = $wpdb->get_var( "SELECT VERSION() AS version" );
	    $mysql_info = $wpdb->get_results( "SHOW VARIABLES LIKE 'sql_mode'" );
	    if ( is_array( $mysql_info) )
	    	$sql_mode = $mysql_info[0]->Value;
	    if ( empty( $sql_mode ) )
	    	$sql_mode = __( 'Not set', 'twitter' );
	    if ( ini_get( 'safe_mode' ) )
	    	$safe_mode = __( 'On', 'twitter' );
	    else
	    	$safe_mode = __( 'Off', 'twitter' );
	    if ( ini_get( 'allow_url_fopen' ) )
	    	$allow_url_fopen = __( 'On', 'twitter' );
	    else
	    	$allow_url_fopen = __( 'Off', 'twitter' );
	    if ( ini_get( 'upload_max_filesize' ) )
	    	$upload_max_filesize = ini_get( 'upload_max_filesize' );
	    else
	    	$upload_max_filesize = __( 'N/A', 'twitter' );
	    if ( ini_get('post_max_size') )
	    	$post_max_size = ini_get('post_max_size');
	    else
	    	$post_max_size = __( 'N/A', 'twitter' );
	    if ( ini_get( 'max_execution_time' ) )
	    	$max_execution_time = ini_get( 'max_execution_time' );
	    else
	    	$max_execution_time = __( 'N/A', 'twitter' );
	    if ( ini_get( 'memory_limit' ) )
	    	$memory_limit = ini_get( 'memory_limit' );
	    else
	    	$memory_limit = __( 'N/A', 'twitter' );
	    if ( function_exists( 'memory_get_usage' ) )
	    	$memory_usage = round( memory_get_usage() / 1024 / 1024, 2 ) . __(' Mb', 'twitter' );
	    else
	    	$memory_usage = __( 'N/A', 'twitter' );
	    if ( is_callable( 'exif_read_data' ) )
	    	$exif_read_data = __( 'Yes', 'twitter' ) . " ( V" . substr( phpversion( 'exif' ), 0,4 ) . ")" ;
	    else
	    	$exif_read_data = __( 'No', 'twitter' );
	    if ( is_callable( 'iptcparse' ) )
	    	$iptcparse = __( 'Yes', 'twitter' );
	    else
	    	$iptcparse = __( 'No', 'twitter' );
	    if ( is_callable( 'xml_parser_create' ) )
	    	$xml_parser_create = __( 'Yes', 'twitter' );
	    else
	    	$xml_parser_create = __( 'No', 'twitter' );

		if ( function_exists( 'wp_get_theme' ) )
			$theme = wp_get_theme();
		else
			$theme = get_theme( get_current_theme() );

		if ( function_exists( 'is_multisite' ) ) {
			if ( is_multisite() ) {
				$multisite = __( 'Yes', 'twitter' );
			} else {
				$multisite = __( 'No', 'twitter' );
			}
		} else
			$multisite = __( 'N/A', 'twitter' );

		$site_url = get_option( 'siteurl' );
		$home_url = get_option( 'home' );
		$db_version = get_option( 'db_version' );
		$system_info = array(
			'system_info' => '',
			'active_plugins' => '',
			'inactive_plugins' => ''
		);
		$system_info['system_info'] = array(
	        __( 'Operating System', 'twitter' )				=> PHP_OS,
	        __( 'Server', 'twitter' )						=> $_SERVER["SERVER_SOFTWARE"],
	        __( 'Memory usage', 'twitter' )					=> $memory_usage,
	        __( 'MYSQL Version', 'twitter' )				=> $sql_version,
	        __( 'SQL Mode', 'twitter' )						=> $sql_mode,
	        __( 'PHP Version', 'twitter' )					=> PHP_VERSION,
	        __( 'PHP Safe Mode', 'twitter' )				=> $safe_mode,
	        __( 'PHP Allow URL fopen', 'twitter' )			=> $allow_url_fopen,
	        __( 'PHP Memory Limit', 'twitter' )				=> $memory_limit,
	        __( 'PHP Max Upload Size', 'twitter' )			=> $upload_max_filesize,
	        __( 'PHP Max Post Size', 'twitter' )			=> $post_max_size,
	        __( 'PHP Max Script Execute Time', 'twitter' )	=> $max_execution_time,
	        __( 'PHP Exif support', 'twitter' )				=> $exif_read_data,
	        __( 'PHP IPTC support', 'twitter' )				=> $iptcparse,
	        __( 'PHP XML support', 'twitter' )				=> $xml_parser_create,
			__( 'Site URL', 'twitter' )						=> $site_url,
			__( 'Home URL', 'twitter' )						=> $home_url,
			__( 'WordPress Version', 'twitter' )			=> $wp_version,
			__( 'WordPress DB Version', 'twitter' )			=> $db_version,
			__( 'Multisite', 'twitter' )					=> $multisite,
			__( 'Active Theme', 'twitter' )					=> $theme['Name'].' '.$theme['Version']
		);
		foreach ( $all_plugins as $path => $plugin ) {
			if ( is_plugin_active( $path ) ) {
				$system_info['active_plugins'][ $plugin['Name'] ] = $plugin['Version'];
			} else {
				$system_info['inactive_plugins'][ $plugin['Name'] ] = $plugin['Version'];
			}
		} 

		if ( ( isset( $_REQUEST['bwsmn_form_submit'] ) && check_admin_referer( plugin_basename(__FILE__), 'bwsmn_nonce_submit' ) ) ||
			 ( isset( $_REQUEST['bwsmn_form_submit_custom_email'] ) && check_admin_referer( plugin_basename(__FILE__), 'bwsmn_nonce_submit_custom_email' ) ) ) {
			if ( isset( $_REQUEST['bwsmn_form_email'] ) ) {
				$bwsmn_form_email = trim( $_REQUEST['bwsmn_form_email'] );
				if( $bwsmn_form_email == "" || !preg_match( "/^((?:[a-z0-9']+(?:[a-z0-9\-_\.']+)?@[a-z0-9]+(?:[a-z0-9\-\.]+)?\.[a-z]{2,5})[, ]*)+$/i", $bwsmn_form_email ) ) {
					$error = __( "Please enter a valid email address.", 'twitter' );
				} else {
					$email = $bwsmn_form_email;
					$bwsmn_form_email = '';
					$message = __( 'Email with system info is sent to ', 'twitter' ) . $email;			
				}
			} else {
				$email = 'plugin_system_status@bestwebsoft.com';
				$message = __( 'Thank you for contacting us.', 'twitter' );
			}

			if ( $error == '' ) {
				$headers  = 'MIME-Version: 1.0' . "\n";
				$headers .= 'Content-type: text/html; charset=utf-8' . "\n";
				$headers .= 'From: ' . get_option( 'admin_email' );
				$message_text = '<html><head><title>System Info From ' . $home_url . '</title></head><body>
				<h4>Environment</h4>
				<table>';
				foreach ( $system_info['system_info'] as $key => $value ) {
					$message_text .= '<tr><td>'. $key .'</td><td>'. $value .'</td></tr>';	
				}
				$message_text .= '</table>
				<h4>Active Plugins</h4>
				<table>';
				foreach ( $system_info['active_plugins'] as $key => $value ) {	
					$message_text .= '<tr><td scope="row">'. $key .'</td><td scope="row">'. $value .'</td></tr>';	
				}
				$message_text .= '</table>
				<h4>Inactive Plugins</h4>
				<table>';
				foreach ( $system_info['inactive_plugins'] as $key => $value ) {
					$message_text .= '<tr><td scope="row">'. $key .'</td><td scope="row">'. $value .'</td></tr>';
				}
				$message_text .= '</table></body></html>';
				$result = wp_mail( $email, 'System Info From ' . $home_url, $message_text, $headers );
				if ( $result != true )
					$error = __( "Sorry, email message could not be delivered.", 'twitter' );
			}
		}
		?><div class="wrap">
			<div class="icon32 icon32-bws" id="icon-options-general"></div>
			<h2><?php echo $title;?></h2>
			<div class="updated fade" <?php if( !( isset( $_REQUEST['bwsmn_form_submit'] ) || isset( $_REQUEST['bwsmn_form_submit_custom_email'] ) ) || $error != "" ) echo "style=\"display:none\""; ?>><p><strong><?php echo $message; ?></strong></p></div>
			<div class="error" <?php if ( "" == $error ) echo "style=\"display:none\""; ?>><p><strong><?php echo $error; ?></strong></p></div>
			<h3 style="color: blue;"><?php _e( 'Pro plugins', 'twitter' ); ?></h3>
			<?php if( 0 < $count_activate_pro ) { ?>
			<div style="padding-left:15px;">
				<h4><?php _e( 'Activated plugins', 'twitter' ); ?></h4>
				<?php foreach ( $array_activate_pro as $activate_plugin ) { ?>
				<div style="float:left; width:200px;"><?php echo $activate_plugin["title"]; ?></div> <p><a href="<?php echo $activate_plugin["link"]; ?>" target="_blank"><?php echo __( "Read more", 'twitter' ); ?></a> <a href="<?php echo $activate_plugin["url"]; ?>"><?php echo __( "Settings", 'twitter' ); ?></a></p>
				<?php } ?>
			</div>
			<?php } ?>
			<?php if( 0 < $count_install_pro ) { ?>
			<div style="padding-left:15px;">
				<h4><?php _e( 'Installed plugins', 'twitter' ); ?></h4>
				<?php foreach ( $array_install_pro as $install_plugin) { ?>
				<div style="float:left; width:200px;"><?php echo $install_plugin["title"]; ?></div> <p><a href="<?php echo $install_plugin["link"]; ?>" target="_blank"><?php echo __( "Read more", 'twitter' ); ?></a></p>
				<?php } ?>
			</div>
			<?php } ?>
			<?php if( 0 < $count_recomend_pro ) { ?>
			<div style="padding-left:15px;">
				<h4><?php _e( 'Recommended plugins', 'twitter' ); ?></h4>
				<?php foreach ( $array_recomend_pro as $recomend_plugin ) { ?>
				<div style="float:left; width:200px;"><?php echo $recomend_plugin["title"]; ?></div> <p><a href="<?php echo $recomend_plugin["link"]; ?>" target="_blank"><?php echo __( "Read more", 'twitter' ); ?></a> <a href="<?php echo $recomend_plugin["href"]; ?>" target="_blank"><?php echo __( "Purchase", 'twitter' ); ?></a></p>
				<?php } ?>
			</div>
			<?php } ?>
			<br />
			<h3 style="color: green"><?php _e( 'Free plugins', 'twitter' ); ?></h3>
			<?php if( 0 < $count_activate ) { ?>
			<div style="padding-left:15px;">
				<h4><?php _e( 'Activated plugins', 'twitter' ); ?></h4>
				<?php foreach( $array_activate as $activate_plugin ) { ?>
				<div style="float:left; width:200px;"><?php echo $activate_plugin["title"]; ?></div> <p><a href="<?php echo $activate_plugin["link"]; ?>" target="_blank"><?php echo __( "Read more", 'twitter' ); ?></a> <a href="<?php echo $activate_plugin["url"]; ?>"><?php echo __( "Settings", 'twitter' ); ?></a></p>
				<?php } ?>
			</div>
			<?php } ?>
			<?php if( 0 < $count_install ) { ?>
			<div style="padding-left:15px;">
				<h4><?php _e( 'Installed plugins', 'twitter' ); ?></h4>
				<?php foreach ( $array_install as $install_plugin ) { ?>
				<div style="float:left; width:200px;"><?php echo $install_plugin["title"]; ?></div> <p><a href="<?php echo $install_plugin["link"]; ?>" target="_blank"><?php echo __( "Read more", 'twitter' ); ?></a></p>
				<?php } ?>
			</div>
			<?php } ?>
			<?php if( 0 < $count_recomend ) { ?>
			<div style="padding-left:15px;">
				<h4><?php _e( 'Recommended plugins', 'twitter' ); ?></h4>
				<?php foreach ( $array_recomend as $recomend_plugin ) { ?>
				<div style="float:left; width:200px;"><?php echo $recomend_plugin["title"]; ?></div> <p><a href="<?php echo $recomend_plugin["link"]; ?>" target="_blank"><?php echo __( "Read more", 'twitter' ); ?></a> <a href="<?php echo $recomend_plugin["href"]; ?>" target="_blank"><?php echo __( "Download", 'twitter' ); ?></a> <a class="install-now" href="<?php echo get_bloginfo( "url" ) . $recomend_plugin["slug"]; ?>" title="<?php esc_attr( sprintf( __( 'Install %s' ), $recomend_plugin["title"] ) ) ?>" target="_blank"><?php echo __( 'Install now from wordpress.org', 'twitter' ) ?></a></p>
				<?php } ?>
			</div>
			<?php } ?>	
			<br />		
			<span style="color: rgb(136, 136, 136); font-size: 10px;"><?php _e( 'If you have any questions, please contact us via', 'twitter' ); ?> <a href="http://support.bestwebsoft.com">http://support.bestwebsoft.com</a></span>
			<div id="poststuff" class="bws_system_info_mata_box">
				<div class="postbox">
					<div class="handlediv" title="Click to toggle">
						<br>
					</div>
					<h3 class="hndle">
						<span><?php _e( 'System status', 'twitter' ); ?></span>
					</h3>
					<div class="inside">
						<table class="bws_system_info">
							<thead><tr><th><?php _e( 'Environment', 'twitter' ); ?></th><td></td></tr></thead>
							<tbody>
							<?php foreach ( $system_info['system_info'] as $key => $value ) { ?>	
								<tr>
									<td scope="row"><?php echo $key; ?></td>
									<td scope="row"><?php echo $value; ?></td>
								</tr>	
							<?php } ?>
							</tbody>
						</table>
						<table class="bws_system_info">
							<thead><tr><th><?php _e( 'Active Plugins', 'twitter' ); ?></th><th></th></tr></thead>
							<tbody>
							<?php foreach ( $system_info['active_plugins'] as $key => $value ) { ?>	
								<tr>
									<td scope="row"><?php echo $key; ?></td>
									<td scope="row"><?php echo $value; ?></td>
								</tr>	
							<?php } ?>
							</tbody>
						</table>
						<table class="bws_system_info">
							<thead><tr><th><?php _e( 'Inactive Plugins', 'twitter' ); ?></th><th></th></tr></thead>
							<tbody>
							<?php foreach ( $system_info['inactive_plugins'] as $key => $value ) { ?>	
								<tr>
									<td scope="row"><?php echo $key; ?></td>
									<td scope="row"><?php echo $value; ?></td>
								</tr>	
							<?php } ?>
							</tbody>
						</table>
						<div class="clear"></div>						
						<form method="post" action="admin.php?page=bws_plugins">
							<p>			
								<input type="hidden" name="bwsmn_form_submit" value="submit" />
								<input type="submit" class="button-primary" value="<?php _e( 'Send to support', 'twitter' ) ?>" />
								<?php wp_nonce_field( plugin_basename(__FILE__), 'bwsmn_nonce_submit' ); ?>		
							</p>		
						</form>				
						<form method="post" action="admin.php?page=bws_plugins">	
							<p>			
								<input type="hidden" name="bwsmn_form_submit_custom_email" value="submit" />						
								<input type="submit" class="button" value="<?php _e( 'Send to custom email &#187;', 'twitter' ) ?>" />
								<input type="text" value="<?php echo $bwsmn_form_email; ?>" name="bwsmn_form_email" />
								<?php wp_nonce_field( plugin_basename(__FILE__), 'bwsmn_nonce_submit_custom_email' ); ?>
							</p>				
						</form>						
					</div>
				</div>
			</div>
		</div>
	<?php }
}

// Register settings for plugin
if( ! function_exists( 'twttr_settings' ) ) {
	function twttr_settings() {
		global $twttr_options_array;

		$twttr_options_array_defaults = array(
			'twttr_url_twitter' => 'admin',
			'twttr_display_option' => 'custom',
			'twttr_count_icon' => 1,
			'twttr_img_link' =>  plugins_url( "images/twitter-follow.gif", __FILE__ ),
			'twttr_position' => '',
			'twttr_disable' => '0'
		);

		if( ! get_option( 'twttr_options_array' ) )
			add_option( 'twttr_options_array', $twttr_options_array_defaults, '', 'yes' );

		$twttr_options_array = get_option( 'twttr_options_array' );
		$twttr_options_array = array_merge( $twttr_options_array_defaults, $twttr_options_array );
	}
}

//add meny
if(!function_exists ( 'twttr_add_pages' ) ) {
	function twttr_add_pages() {
		add_menu_page( 'BWS Plugins', 'BWS Plugins', 'manage_options', 'bws_plugins', 'bws_add_menu_render', plugins_url( 'images/px.png', __FILE__ ), 1001); 
		add_submenu_page('bws_plugins', __( 'Twitter Settings', 'twitter' ), __( 'Twitter', 'twitter' ), 'manage_options', 'twitter.php', 'twttr_settings_page');

		//call register settings function
		add_action( 'admin_init', 'twttr_settings' );
	}
}
//add meny.End
		
//add.Form meny.
if (!function_exists ( 'twttr_settings_page' ) ) {
	function twttr_settings_page () {
		global $twttr_options_array;
		$copy = false;
		
		if( @copy( plugin_dir_path( __FILE__ )."images/twitter-follow.jpg", plugin_dir_path( __FILE__ )."images/twitter-follow1.jpg" ) !== false )
			$copy = true;

		$message = "";
		$error = "";
		if ( isset( $_REQUEST['twttr_form_submit'] ) && check_admin_referer( plugin_basename(__FILE__), 'twttr_nonce_name' ) ) {
			$twttr_options_array['twttr_url_twitter'] = $_REQUEST['twttr_url_twitter'];
			$twttr_options_array['twttr_display_option' ] =	$_REQUEST['twttr_display_option'];
			$twttr_options_array['twttr_position'] = $_REQUEST['twttr_position'];
			$twttr_options_array['twttr_disable'] = isset( $_REQUEST["twttr_disable"] ) ? 1 : 0;
			if ( isset( $_FILES['upload_file']['tmp_name'] ) &&  $_FILES['upload_file']['tmp_name'] != "" ) {		
				$twttr_options_array['twttr_count_icon'] = $twttr_options_array['twttr_count_icon'] + 1;				
			}
			if ( $twttr_options_array['twttr_count_icon'] > 2 )
				$twttr_options_array['twttr_count_icon'] = 1;

			update_option( 'twttr_options_array', $twttr_options_array );
			$message = __( "Settings saved", 'twitter' );
			
			// Form options
			if ( isset ( $_FILES['upload_file']['tmp_name'] ) &&  $_FILES['upload_file']['tmp_name'] != "" ) {		
				$max_image_width	=	100;
				$max_image_height	=	100;
				$max_image_size		=	32 * 1024;
				$valid_types 		=	array( 'jpg', 'jpeg' );
				// Construction to rename downloading file
				$new_name			=	'twitter-follow'.$twttr_options_array['twttr_count_icon']; 
				$new_ext			=	'.jpg';
				$namefile			=	$new_name.$new_ext;
				$uploaddir			=	$_REQUEST['home'] . 'wp-content/plugins/twitter-plugin/images/'; // The directory in which we will take the file:
				$uploadfile			=	$uploaddir.$namefile; 

				//checks is file download initiated by user
				if ( isset ( $_FILES['upload_file'] ) && $_REQUEST['twttr_display_option'] == 'custom' )	{		
					//Checking is allowed download file given parameters
					if ( is_uploaded_file( $_FILES['upload_file']['tmp_name'] ) ) {	
						$filename	=	$_FILES['upload_file']['tmp_name'];
						$ext		=	substr( $_FILES['upload_file']['name'], 1 + strrpos( $_FILES['upload_file']['name'], '.' ) );		
						if ( filesize ( $filename ) > $max_image_size ) {
							$error = __( "Error: File size > 32K", 'twitter' );
						} elseif ( ! in_array ( $ext, $valid_types ) ) { 
							$error = __( "Error: Invalid file type", 'twitter' );
						} else {
							$size = GetImageSize( $filename );
							if ( ( $size ) && ( $size[0] <= $max_image_width ) && ( $size[1] <= $max_image_height ) ) {
								//If file satisfies requirements, we will move them from temp to your plugin folder and rename to 'twitter_ico.jpg'
								if ( move_uploaded_file ( $_FILES['upload_file']['tmp_name'], $uploadfile ) ) { 
									$message .= '. ' ."Upload successful.";
								} else { 
									$error = __( "Error: moving file failed", 'twitter' );
								}
							} else { 
								$error = __( "Error: check image width or height", 'twitter' );
							}
						}
					} else { 
						$error = __( "Uploading Error: check image properties", 'twitter' );
					}	
				}
			}			
		} 
		twttr_update_option(); ?>
		<div class="wrap">
			<div class="icon32 icon32-bws" id="icon-options-general"></div>
			<h2><?php echo __( "Twitter Settings", 'twitter' ); ?></h2>
			<div class="updated fade" <?php if( empty( $message ) || $error != "" ) echo "style=\"display:none\""; ?>><p><strong><?php echo $message; ?></strong></p></div>
			<div class="error" <?php if( "" == $error ) echo "style=\"display:none\""; ?>><p><strong><?php echo $error; ?></strong></p></div>
			<div>
				<form method='post' action="admin.php?page=twitter.php" enctype="multipart/form-data">
					<table class="form-table">
						<tr valign="top">
							<th scope="row" colspan="2"><?php echo __( 'Settings for the button "Follow Me":', 'twitter' ); ?></th>
						</tr>					
						<tr valign="top">
							<th scope="row">
								<?php echo __( "Enter your username:", 'twitter' ); ?>
							</th>
							<td>
								<input name='twttr_url_twitter' type='text' value='<?php echo $twttr_options_array['twttr_url_twitter'] ?>'/><br />
								<span style="color: rgb(136, 136, 136); font-size: 10px;"><?php echo __( 'If you do not have Twitter account yet, you should create it using this link', 'twitter' ); ?> <a target="_blank" href="https://twitter.com/signup">https://twitter.com/signup</a> .</span><br />
								<span style="color: rgb(136, 136, 136); font-size: 10px;"><?php echo __( 'Paste the shortcode [follow_me] into the necessary page or post to use the "Follow Me" button.', 'twitter' ); ?></span><br />
								<span style="color: rgb(136, 136, 136); font-size: 10px;"><?php echo __( 'If you would like to use this button in some other place, please paste this line into the template source code', 'twitter' ); ?>	&#60;?php if ( function_exists( 'follow_me' ) ) echo follow_me(); ?&#62;</span>
							</td>
						</tr>						
						<tr valign="top">
							<th scope="row">
								<?php echo __( "Choose display settings:", 'twitter' ); ?>
							</th>
							<td>
								<select name="twttr_display_option" onchange="if ( this . value == 'custom' ) { getElementById ( 'twttr_display_option_custom' ) . style.display = 'block'; } else { getElementById ( 'twttr_display_option_custom' ) . style.display = 'none'; }">
									<option <?php if ( $twttr_options_array['twttr_display_option'] == 'standart' ) echo 'selected="selected"'; ?> value="standart"><?php echo __( "Standard button", 'twitter' ); ?></option>
									<?php if( $copy || $twttr_options_array['twttr_display_option'] == 'custom' ) { ?>
									<option <?php if ( $twttr_options_array['twttr_display_option'] == 'custom' ) echo 'selected="selected"'; ?> value="custom"><?php echo __( "Custom button", 'twitter' ); ?></option>
									<?php } ?>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<div id="twttr_display_option_custom" <?php if ( $twttr_options_array['twttr_display_option'] == 'custom' ) { echo ( 'style="display:block"' ); } else {echo ( 'style="display:none"' ); }?>>
									<table>
										<th style="padding-left:0px;font-size:13px;">
											<?php echo __( "Current image:", 'twitter' ); ?>
										</th>
										<td>
											<img src="<?php echo $twttr_options_array['twttr_img_link']; ?>" />
										</td>
									</table>											
									<table>
										<th style="padding-left:0px;font-size:13px;">											
											<?php echo __( "\"Follow Me\" image:", 'twitter' ); ?>
										</th>
										<td>
											<input type="hidden" name="MAX_FILE_SIZE" value="64000"/>
											<input type="hidden" name="home" value="<?php echo ABSPATH ; ?>"/>
											<input type="file" name="upload_file" style="width:196px;" /><br />
											<span style="color: rgb(136, 136, 136); font-size: 10px;"><?php echo __( 'Image properties: max image width:100px; max image height:100px; max image size:32Kb; image types:"jpg", "jpeg".', 'twitter' ); ?></span>	
										</td>
									</table>											
								</div>
							</td>
						</tr>
						<tr valign="top">
							<th scope="row" colspan="2"><?php echo __( '"Twitter" button settings:', 'twitter' ); ?></th>
						</tr>					
						<tr>
							<th><?php echo __( 'Disable the "Twitter" button:', 'twitter' ); ?></th>							
							<td>
								<input type="checkbox" name="twttr_disable" value="1" <?php if( 1 == $twttr_options_array["twttr_disable"] ) echo "checked=\"checked\""; ?> /><br />
								<span style="color: rgb(136, 136, 136); font-size: 10px;"><?php echo __( 'The button "T" will not be displayed. Just the shortcode [follow_me] will work.', 'twitter' ); ?></span><br />
							</td>
						</tr>
						<tr>
							<th>
								<?php echo __( 'Choose the "Twitter" icon position:', 'twitter' ); ?>
							</th>
							<td>
								<input style="margin-top:3px;" type="radio" name="twttr_position" value="1" <?php if ( $twttr_options_array['twttr_position'] == 1 ) echo 'checked="checked"'?> /> <label for="twttr_position"><?php echo __( 'Top position', 'twitter' ); ?></label><br />
								<input style="margin-top:3px;" type="radio" name="twttr_position" value="0" <?php if ( $twttr_options_array['twttr_position'] == 0 ) echo 'checked="checked"'?> /> <label for="twttr_position"><?php echo __( 'Bottom position', 'twitter' ); ?></label><br />
								<span style="color: rgb(136, 136, 136); font-size: 10px;"><?php echo __( 'By clicking this icon a user can add the article he/she likes to his/her Twitter page.', 'twitter' ); ?></span><br />
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<input type="hidden" name="twttr_form_submit" value="submit" />
								<input type="submit" class="button-primary" value="<?php _e( 'Save Changes' ) ?>" />
							</td>
						</tr>
					</table>
					<?php wp_nonce_field( plugin_basename(__FILE__), 'twttr_nonce_name' ); ?>
				</form>
			</div>
		</div>
	<?php
	}		
}
//add.Form meny.End.

//Function 'twitter_twttr_display_option' reacts to changes type of picture (Standard or Custom) and generates link to image, link transferred to array 'twttr_options_array'
if( ! function_exists( 'twttr_update_option' ) ) {
	function twttr_update_option () {
		global $twttr_options_array;
		if ( $twttr_options_array [ 'twttr_display_option' ] == 'standart' ){
			$twttr_img_link	=	plugins_url( 'images/twitter-follow.jpg', __FILE__ );
		} else if ( $twttr_options_array['twttr_display_option'] == 'custom') {
			$twttr_img_link	= plugins_url( 'images/twitter-follow'.$twttr_options_array['twttr_count_icon'].'.jpg', __FILE__ );
		}
		$twttr_options_array['twttr_img_link'] = $twttr_img_link;
		update_option( "twttr_options_array", $twttr_options_array );
	}
}	
	
// score code[follow_me]
if (!function_exists('twttr_follow_me')){
	function twttr_follow_me() {
		global $twttr_options_array;

		if ( $twttr_options_array [ 'twttr_display_option' ] == 'standart' ){
			return '<div class="twttr_follow">
			    <a href="https://twitter.com/'.$twttr_options_array["twttr_url_twitter"].'" class="twitter-follow-button" data-show-count="true">Follow me</a>
			    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
				</div>';
		} else {
			return '<div class="twttr_follow"><a href="http://twitter.com/'.$twttr_options_array["twttr_url_twitter"].'" target="_blank" title="Follow me">
				 <img src="'.$twttr_options_array['twttr_img_link'].'" alt="Follow me" />
			  </a></div>';
		}		
	}
}
	
//Positioning in the page	
if(!function_exists( 'twttr_twit' ) ) {
	function twttr_twit( $content ) {
		global $post;
		global $twttr_options_array;
		$permalink_post = get_permalink($post->ID);
		$title_post = $post->post_title;
		if ( $title_post == 'your-post-page-title' )
			return $content;

		if ( 0 == $twttr_options_array['twttr_disable'] ) {
			$position = $twttr_options_array['twttr_position'];
			$str = '<div class="twttr_button">
					<a href="http://twitter.com/share?url='.$permalink_post.'&text='.$title_post.'" target="_blank" title="'.__( 'Click here if you like this article.', 'twitter' ).'">
						<img src="'.plugins_url('images/twitt.gif', __FILE__).'" alt="Twitt" />
					</a>
				</div>';
			if ( $position ) {
				return $str.$content;
			} else {
				return $content.$str;
			}
		} else {
			return $content;
		}
	}
}
//Positioning in the page.End.

function twttr_action_links( $links, $file ) {
		//Static so we don't call plugin_basename on every plugin row.
	static $this_plugin;
	if ( ! $this_plugin ) $this_plugin = plugin_basename(__FILE__);

	if ( $file == $this_plugin ){
			 $settings_link = '<a href="admin.php?page=twitter.php">' . __( 'Settings', 'twitter' ) . '</a>';
			 array_unshift( $links, $settings_link );
		}
	return $links;
} // end function twttr_bttn_plgn_action_links

function twttr_links($links, $file) {
	$base = plugin_basename(__FILE__);
	if ($file == $base) {
		$links[] = '<a href="admin.php?page=twitter.php">' . __( 'Settings','twitter' ) . '</a>';
		$links[] = '<a href="http://wordpress.org/extend/plugins/twitter-plugin/faq/" target="_blank">' . __( 'FAQ','twitter' ) . '</a>';
		$links[] = '<a href="http://support.bestwebsoft.com">' . __( 'Support','twitter' ) . '</a>';
	}
	return $links;
}

//Function '_plugin_init' are using to add language files.
if ( ! function_exists ( 'twttr_plugin_init' ) ) {
	function twttr_plugin_init() {
		load_plugin_textdomain( 'twitter', false, dirname( plugin_basename( __FILE__ ) ) . '/languages/' ); 
	}
} // end function twttr_plugin_init


if ( ! function_exists ( 'twttr_admin_head' ) ) {
	function twttr_admin_head() {
		wp_register_style( 'twttrStylesheet', plugins_url( 'css/style.css', __FILE__ ) );
		wp_enqueue_style( 'twttrStylesheet' );

		if ( isset( $_GET['page'] ) && $_GET['page'] == "bws_plugins" )
			wp_enqueue_script( 'bws_menu_script', plugins_url( 'js/bws_menu.js' , __FILE__ ) );
	}
}

// Function for delete options 
if ( ! function_exists ( 'twttr_delete_options' ) ) {
	function twttr_delete_options() {
		global $wpdb;
		delete_option( 'twttr_options_array' );
	}
}

add_action( 'init', 'twttr_plugin_init' );
add_action( 'init', 'twttr_settings' );

add_action( 'admin_enqueue_scripts', 'twttr_admin_head' );
add_action( 'wp_enqueue_scripts', 'twttr_admin_head' );

// adds "Settings" link to the plugin action page
add_filter( 'plugin_action_links', 'twttr_action_links',10,2);

//Additional links on the plugin page
add_filter( 'plugin_row_meta', 'twttr_links',10,2);

add_filter( "the_content", "twttr_twit" );

add_action ( 'admin_menu', 'twttr_add_pages' );

add_shortcode( 'follow_me', 'twttr_follow_me' );

register_uninstall_hook( __FILE__, 'twttr_delete_options' );
?>