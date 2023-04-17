/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2.mailmap;


private static import libgit2.types;

/*
 * @file git2/mailmap.h
 * @brief Mailmap parsing routines
 * @defgroup git_mailmap Git mailmap routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Allocate a new mailmap object.
 *
 * This object is empty, so you'll have to add a mailmap file before you can do
 * anything with it. The mailmap must be freed with 'git_mailmap_free'.
 *
 * Params:
 *      out_ = pointer to store the new mailmap
 *
 * Returns: 0 on success, or an error code
 */
//GIT_EXTERN
int git_mailmap_new(libgit2.types.git_mailmap** out_);

/**
 * Free the mailmap and its associated memory.
 *
 * Params:
 *      mm = the mailmap to free
 */
//GIT_EXTERN
void git_mailmap_free(libgit2.types.git_mailmap* mm);

/**
 * Add a single entry to the given mailmap object. If the entry already exists,
 * it will be replaced with the new entry.
 *
 * Params:
 *      mm = mailmap to add the entry to
 *      real_name = the real name to use, or NULL
 *      real_email = the real email to use, or NULL
 *      replace_name = the name to replace, or NULL
 *      replace_email = the email to replace
 *
 * Returns: 0 on success, or an error code
 */
//GIT_EXTERN
int git_mailmap_add_entry(libgit2.types.git_mailmap* mm, const (char)* real_name, const (char)* real_email, const (char)* replace_name, const (char)* replace_email);

/**
 * Create a new mailmap instance containing a single mailmap file
 *
 * Params:
 *      out_ = pointer to store the new mailmap
 *      buf = buffer to parse the mailmap from
 *      len = the length of the input buffer
 *
 * Returns: 0 on success, or an error code
 */
//GIT_EXTERN
int git_mailmap_from_buffer(libgit2.types.git_mailmap** out_, const (char)* buf, size_t len);

/**
 * Create a new mailmap instance from a repository, loading mailmap files based
 * on the repository's configuration.
 *
 * Mailmaps are loaded in the following order:
 *  1. '.mailmap' in the root of the repository's working directory, if present.
 *  2. The blob object identified by the 'mailmap.blob' config entry, if set.
 * 	   [NOTE: 'mailmap.blob' defaults to 'HEAD:.mailmap' in bare repositories]
 *  3. The path in the 'mailmap.file' config entry, if set.
 *
 * Params:
 *      out_ = pointer to store the new mailmap
 *      repo = repository to load mailmap information from
 *
 * Returns: 0 on success, or an error code
 */
//GIT_EXTERN
int git_mailmap_from_repository(libgit2.types.git_mailmap** out_, libgit2.types.git_repository* repo);

/**
 * Resolve a name and email to the corresponding real name and email.
 *
 * The lifetime of the strings are tied to `mm`, `name`, and `email` parameters.
 *
 * Params:
 *      real_name = pointer to store the real name
 *      real_email = pointer to store the real email
 *      mm = the mailmap to perform a lookup with (may be NULL)
 *      name = the name to look up
 *      email = the email to look up
 *
 * Returns: 0 on success, or an error code
 */
//GIT_EXTERN
int git_mailmap_resolve(const (char)** real_name, const (char)** real_email, const (libgit2.types.git_mailmap)* mm, const (char)* name, const (char)* email);

/**
 * Resolve a signature to use real names and emails with a mailmap.
 *
 * Call `git_signature_free()` to free the data.
 *
 * Params:
 *      out_ = new signature
 *      mm = mailmap to resolve with
 *      sig = signature to resolve
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_mailmap_resolve_signature(libgit2.types.git_signature** out_, const (libgit2.types.git_mailmap)* mm, const (libgit2.types.git_signature)* sig);

/* @} */
