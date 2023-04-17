/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2.credential_helpers;


private static import libgit2.credential;

/*
 * @file git2/credential_helpers.h
 * @brief Utility functions for credential management
 * @defgroup git_credential_helpers credential management helpers
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Payload for git_credential_userpass_plaintext.
 */
struct git_credential_userpass_payload
{
	const (char)* username;
	const (char)* password;
}

/**
 * Stock callback usable as a git_credential_acquire_cb.  This calls
 * git_cred_userpass_plaintext_new unless the protocol has not specified
 * `git_credential_t.GIT_CREDENTIAL_USERPASS_PLAINTEXT` as an allowed type.
 *
 * Params:
 *      out_ = The newly created credential object.
 *      url = The resource for which we are demanding a credential.
 *      user_from_url = The username that was embedded in a "user\@host" remote url, or NULL if not included.
 *      allowed_types = A bitmask stating which credential types are OK to return.
 *      payload = The payload provided when specifying this callback.  (This is interpreted as a `git_credential_userpass_payload*`.)
 */
//GIT_EXTERN
int git_credential_userpass(libgit2.credential.git_credential** out_, const (char)* url, const (char)* user_from_url, uint allowed_types, void* payload);

/* @} */
