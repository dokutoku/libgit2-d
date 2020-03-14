/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.sys.credential;


private static import libgit2_d.credential;

/**
 * @file git2/sys/cred.h
 * @brief Git credentials low-level implementation
 * @defgroup git_credential Git credentials low-level implementation
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
package(libgit2_d):

/**
 * The base structure for all credential types
 */
struct git_credential
{
	/**
	 * A type of credential
	 */
	libgit2_d.credential.git_credential_t credtype;

	/**
	 * The deallocator for this type of credentials
	 */
	void function(.git_credential* cred) free;
}

/**
 * A plaintext username and password
 */
struct git_credential_userpass_plaintext
{
	/**
	 * The parent credential
	 */
	.git_credential parent;

	/**
	 * The username to authenticate as
	 */
	char* username;

	/**
	 * The password to use
	 */
	char* password;
}

/**
 * Username-only credential information
 */
struct git_credential_username
{
	/**
	 * The parent credential
	 */
	.git_credential parent;

	/**
	 * The username to authenticate as.
	 *
	 * This member is treated as an array.
	 */
	char username;
}

/**
 * A ssh key from disk
 */
struct git_credential_ssh_key
{
	/**
	 * The parent credential
	 */
	.git_credential parent;

	/**
	 * The username to authenticate as
	 */
	char* username;

	/**
	 * The path to a public key
	 */
	char* publickey;

	/**
	 * The path to a private key
	 */
	char* privatekey;

	/**
	 * Passphrase to decrypt the private key
	 */
	char* passphrase;
}

/**
 * Keyboard-interactive based ssh authentication
 */
struct git_credential_ssh_interactive
{
	/**
	 * The parent credential
	 */
	.git_credential parent;

	/**
	 * The username to authenticate as
	 */
	char* username;

	/**
	 * Callback used for authentication.
	 */
	libgit2_d.credential.git_credential_ssh_interactive_cb prompt_callback;

	/**
	 * Payload passed to prompt_callback
	 */
	void* payload;
}

/**
 * A key with a custom signature function
 */
struct git_credential_ssh_custom
{
	/**
	 * The parent credential
	 */
	.git_credential parent;

	/**
	 * The username to authenticate as
	 */
	char* username;

	/**
	 * The public key data
	 */
	char* publickey;

	/**
	 * Length of the public key
	 */
	size_t publickey_len;

	/**
	 * Callback used to sign the data.
	 */
	libgit2_d.credential.git_credential_sign_cb sign_callback;

	/**
	 * Payload passed to prompt_callback
	 */
	void* payload;
}
