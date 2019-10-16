/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.transport;


private static import libgit2_d.indexer;
private static import libgit2_d.net;
private static import libgit2_d.types;

/**
 * @file git2/transport.h
 * @brief Git transport interfaces and functions
 * @defgroup git_transport interfaces and functions
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:

/** Signature of a function which creates a transport */
alias git_transport_cb = int function(libgit2_d.sys.transport.git_transport** out_, libgit2_d.types.git_remote* owner, void* param);

/**
 * Type of SSH host fingerprint
 */
enum git_cert_ssh_t
{
	/** MD5 is available */
	GIT_CERT_SSH_MD5 = (1 << 0),
	/** SHA-1 is available */
	GIT_CERT_SSH_SHA1 = (1 << 1),
}

/**
 * Hostkey information taken from libssh2
 */
struct git_cert_hostkey
{
	libgit2_d.types.git_cert parent;

	/**
	 * A hostkey type from libssh2, either
	 * `GIT_CERT_SSH_MD5` or `GIT_CERT_SSH_SHA1`
	 */
	.git_cert_ssh_t type;

	/**
	 * Hostkey hash. If type has `GIT_CERT_SSH_MD5` set, this will
	 * have the MD5 hash of the hostkey.
	 */
	ubyte[16] hash_md5;

	/**
	 * Hostkey hash. If type has `GIT_CERT_SSH_SHA1` set, this will
	 * have the SHA-1 hash of the hostkey.
	 */
	ubyte[20] hash_sha1;
}

/**
 * X.509 certificate information
 */
struct git_cert_x509
{
	libgit2_d.types.git_cert parent;
	/**
	 * Pointer to the X.509 certificate data
	 */
	void* data;
	/**
	 * Length of the memory block pointed to by `data`.
	 */
	size_t len;
}

/*
 *** Begin interface for credentials acquisition ***
 */

/** Authentication type requested */
enum git_credtype_t
{
	/* git_cred_userpass_plaintext */
	GIT_CREDTYPE_USERPASS_PLAINTEXT = (1u << 0),

	/* git_cred_ssh_key */
	GIT_CREDTYPE_SSH_KEY = (1u << 1),

	/* git_cred_ssh_custom */
	GIT_CREDTYPE_SSH_CUSTOM = (1u << 2),

	/* git_cred_default */
	GIT_CREDTYPE_DEFAULT = (1u << 3),

	/* git_cred_ssh_interactive */
	GIT_CREDTYPE_SSH_INTERACTIVE = (1u << 4),

	/**
	 * Username-only information
	 *
	 * If the SSH transport does not know which username to use,
	 * it will ask via this credential type.
	 */
	GIT_CREDTYPE_USERNAME = (1u << 5),

	/**
	 * Credentials read from memory.
	 *
	 * Only available for libssh2+OpenSSL for now.
	 */
	GIT_CREDTYPE_SSH_MEMORY = (1u << 6),
}

/* The base structure for all credential types */
struct git_cred
{
	.git_credtype_t credtype;
	void function(.git_cred* cred) free;
}

/** A plaintext username and password */
struct git_cred_userpass_plaintext
{
	.git_cred parent;
	char* username;
	char* password;
}

/*
 * If the user hasn't included libssh2.h before git2.h, we need to
 * define a few types for the callback signatures.
 */
//#if !defined(LIBSSH2_VERSION)
	struct _LIBSSH2_SESSION;
	struct _LIBSSH2_USERAUTH_KBDINT_PROMPT;
	struct _LIBSSH2_USERAUTH_KBDINT_RESPONSE;
	alias LIBSSH2_SESSION = _LIBSSH2_SESSION;
	alias LIBSSH2_USERAUTH_KBDINT_PROMPT = _LIBSSH2_USERAUTH_KBDINT_PROMPT;
	alias LIBSSH2_USERAUTH_KBDINT_RESPONSE = _LIBSSH2_USERAUTH_KBDINT_RESPONSE;
//#endif

alias git_cred_sign_callback = int function(.LIBSSH2_SESSION* session, ubyte** sig, size_t* sig_len, const ubyte* data, size_t data_len, void** abstract_);
alias git_cred_ssh_interactive_callback = void function(const (char)* name, int name_len, const (char)* instruction, int instruction_len, int num_prompts, const (.LIBSSH2_USERAUTH_KBDINT_PROMPT)* prompts, .LIBSSH2_USERAUTH_KBDINT_RESPONSE* responses, void** abstract_);

/**
 * A ssh key from disk
 */
struct git_cred_ssh_key
{
	.git_cred parent;
	char* username;
	char* publickey;
	char* privatekey;
	char* passphrase;
}

/**
 * Keyboard-interactive based ssh authentication
 */
struct git_cred_ssh_interactive
{
	.git_cred parent;
	char* username;
	.git_cred_ssh_interactive_callback prompt_callback;
	void* payload;
}

/**
 * A key with a custom signature function
 */
struct git_cred_ssh_custom
{
	.git_cred parent;
	char* username;
	char* publickey;
	size_t publickey_len;
	.git_cred_sign_callback sign_callback;
	void* payload;
}

/** A key for NTLM/Kerberos "default" credentials */
.git_cred git_cred_default;

/** Username-only credential information */
struct git_cred_username
{
	.git_cred parent;
	char[1] username;
}

/**
 * Check whether a credential object contains username information.
 *
 * @param cred object to check
 * @return 1 if the credential object has non-null username, 0 otherwise
 */
//GIT_EXTERN
int git_cred_has_username(.git_cred* cred);

/**
 * Create a new plain-text username and password credential object.
 * The supplied credential parameter will be internally duplicated.
 *
 * @param out_ The newly created credential object.
 * @param username The username of the credential.
 * @param password The password of the credential.
 * @return 0 for success or an error code for failure
 */
//GIT_EXTERN
int git_cred_userpass_plaintext_new(.git_cred** out_, const (char)* username, const (char)* password);

/**
 * Create a new passphrase-protected ssh key credential object.
 * The supplied credential parameter will be internally duplicated.
 *
 * @param out_ The newly created credential object.
 * @param username username to use to authenticate
 * @param publickey The path to the public key of the credential.
 * @param privatekey The path to the private key of the credential.
 * @param passphrase The passphrase of the credential.
 * @return 0 for success or an error code for failure
 */
//GIT_EXTERN
int git_cred_ssh_key_new(.git_cred** out_, const (char)* username, const (char)* publickey, const (char)* privatekey, const (char)* passphrase);

/**
 * Create a new ssh keyboard-interactive based credential object.
 * The supplied credential parameter will be internally duplicated.
 *
 * @param username Username to use to authenticate.
 * @param prompt_callback The callback method used for prompts.
 * @param payload Additional data to pass to the callback.
 * @return 0 for success or an error code for failure.
 */
//GIT_EXTERN
int git_cred_ssh_interactive_new(.git_cred** out_, const (char)* username, git_cred_ssh_interactive_callback prompt_callback, void* payload);

/**
 * Create a new ssh key credential object used for querying an ssh-agent.
 * The supplied credential parameter will be internally duplicated.
 *
 * @param out_ The newly created credential object.
 * @param username username to use to authenticate
 * @return 0 for success or an error code for failure
 */
//GIT_EXTERN
int git_cred_ssh_key_from_agent(.git_cred** out_, const (char)* username);

/**
 * Create an ssh key credential with a custom signing function.
 *
 * This lets you use your own function to sign the challenge.
 *
 * This function and its credential type is provided for completeness
 * and wraps `libssh2_userauth_publickey()`, which is undocumented.
 *
 * The supplied credential parameter will be internally duplicated.
 *
 * @param out_ The newly created credential object.
 * @param username username to use to authenticate
 * @param publickey The bytes of the public key.
 * @param publickey_len The length of the public key in bytes.
 * @param sign_callback The callback method to sign the data during the
 * challenge.
 * @param payload Additional data to pass to the callback.
 * @return 0 for success or an error code for failure
 */
//GIT_EXTERN
int git_cred_ssh_custom_new(.git_cred** out_, const (char)* username, const (char)* publickey, size_t publickey_len, .git_cred_sign_callback sign_callback, void* payload);

/**
 * Create a "default" credential usable for Negotiate mechanisms like NTLM
 * or Kerberos authentication.
 *
 * @return 0 for success or an error code for failure
 */
//GIT_EXTERN
int git_cred_default_new(.git_cred** out_);

/**
 * Create a credential to specify a username.
 *
 * This is used with ssh authentication to query for the username if
 * none is specified in the url.
 */
//GIT_EXTERN
int git_cred_username_new(.git_cred** cred, const (char)* username);

/**
 * Create a new ssh key credential object reading the keys from memory.
 *
 * @param out_ The newly created credential object.
 * @param username username to use to authenticate.
 * @param publickey The public key of the credential.
 * @param privatekey The private key of the credential.
 * @param passphrase The passphrase of the credential.
 * @return 0 for success or an error code for failure
 */
//GIT_EXTERN
int git_cred_ssh_key_memory_new(.git_cred** out_, const (char)* username, const (char)* publickey, const (char)* privatekey, const (char)* passphrase);

/**
 * Free a credential.
 *
 * This is only necessary if you own the object; that is, if you are a
 * transport.
 *
 * @param cred the object to free
 */
//GIT_EXTERN
void git_cred_free(.git_cred* cred);

/**
 * Signature of a function which acquires a credential object.
 *
 * @param cred The newly created credential object.
 * @param url The resource for which we are demanding a credential.
 * @param username_from_url The username that was embedded in a "user\@host"
 *                          remote url, or null if not included.
 * @param allowed_types A bitmask stating which cred types are OK to return.
 * @param payload The payload provided when specifying this callback.
 * @return 0 for success, < 0 to indicate an error, > 0 to indicate
 *       no credential was acquired
 */
alias git_cred_acquire_cb = int function(.git_cred** cred, const (char)* url, const (char)* username_from_url, uint allowed_types, void* payload);

/** @} */
