/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.signature;


private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/signature.h
 * @brief Git signature creation
 * @defgroup libgit2.types.git_signature Git signature creation
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Create a new action signature.
 *
 * Call `git_signature_free()` to free the data.
 *
 * Note: angle brackets ('<' and '>') characters are not allowed
 * to be used in either the `name` or the `email` parameter.
 *
 * Params:
 *      out_ = new signature, in case of error null
 *      name = name of the person
 *      email = email of the person
 *      time = time (in seconds from epoch) when the action happened
 *      offset = timezone offset (in minutes) for the time
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_signature_new(libgit2.types.git_signature** out_, const (char)* name, const (char)* email, libgit2.types.git_time_t time, int offset);

/**
 * Create a new action signature with a timestamp of 'now'.
 *
 * Call `git_signature_free()` to free the data.
 *
 * Params:
 *      out_ = new signature, in case of error null
 *      name = name of the person
 *      email = email of the person
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_signature_now(libgit2.types.git_signature** out_, const (char)* name, const (char)* email);

/**
 * Create a new action signature with default user and now timestamp.
 *
 * This looks up the user.name and user.email from the configuration and
 * uses the current time as the timestamp, and creates a new signature
 * based on that information.  It will return git_error_code.GIT_ENOTFOUND if either the
 * user.name or user.email are not set.
 *
 * Params:
 *      out_ = new signature
 *      repo = repository pointer
 *
 * Returns: 0 on success, git_error_code.GIT_ENOTFOUND if config is missing, or error code
 */
@GIT_EXTERN
int git_signature_default(libgit2.types.git_signature** out_, libgit2.types.git_repository* repo);

/**
 * Create a new signature by parsing the given buffer, which is
 * expected to be in the format "Real Name <email> timestamp tzoffset",
 * where `timestamp` is the number of seconds since the Unix epoch and
 * `tzoffset` is the timezone offset in `hhmm` format (note the lack
 * of a colon separator).
 *
 * Params:
 *      out_ = new signature
 *      buf = signature string
 *
 * Returns: 0 on success, or an error code
 */
@GIT_EXTERN
int git_signature_from_buffer(libgit2.types.git_signature** out_, const (char)* buf);

/**
 * Create a copy of an existing signature.  All internal strings are also
 * duplicated.
 *
 * Call `git_signature_free()` to free the data.
 *
 * Params:
 *      dest = pointer where to store the copy
 *      sig = signature to duplicate
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_signature_dup(libgit2.types.git_signature** dest, const (libgit2.types.git_signature)* sig);

/**
 * Free an existing signature.
 *
 * Because the signature is not an opaque structure, it is legal to free it
 * manually, but be sure to free the "name" and "email" strings in addition
 * to the structure itself.
 *
 * Params:
 *      sig = signature to free
 */
@GIT_EXTERN
void git_signature_free(libgit2.types.git_signature* sig);

/* @} */
