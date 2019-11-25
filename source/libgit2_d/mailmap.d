/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.mailmap;


private static import libgit2_d.types;

/**
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
 * @param out_ pointer to store the new mailmap
 * @return 0 on success, or an error code
 */
//GIT_EXTERN
int git_mailmap_new(libgit2_d.types.git_mailmap** out_);

/**
 * Free the mailmap and its associated memory.
 *
 * @param mm the mailmap to free
 */
//GIT_EXTERN
void git_mailmap_free(libgit2_d.types.git_mailmap* mm);

/**
 * Add a single entry to the given mailmap object. If the entry already exists,
 * it will be replaced with the new entry.
 *
 * @param mm mailmap to add the entry to
 * @param real_name the real name to use, or NULL
 * @param real_email the real email to use, or NULL
 * @param replace_name the name to replace, or NULL
 * @param replace_email the email to replace
 * @return 0 on success, or an error code
 */
//GIT_EXTERN
int git_mailmap_add_entry(libgit2_d.types.git_mailmap* mm, const (char)* real_name, const (char)* real_email, const (char)* replace_name, const (char)* replace_email);

/**
 * Create a new mailmap instance containing a single mailmap file
 *
 * @param out_ pointer to store the new mailmap
 * @param buf buffer to parse the mailmap from
 * @param len the length of the input buffer
 * @return 0 on success, or an error code
 */
//GIT_EXTERN
int git_mailmap_from_buffer(libgit2_d.types.git_mailmap** out_, const (char)* buf, size_t len);

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
 * @param out_ pointer to store the new mailmap
 * @param repo repository to load mailmap information from
 * @return 0 on success, or an error code
 */
//GIT_EXTERN
int git_mailmap_from_repository(libgit2_d.types.git_mailmap** out_, libgit2_d.types.git_repository* repo);

/**
 * Resolve a name and email to the corresponding real name and email.
 *
 * The lifetime of the strings are tied to `mm`, `name`, and `email` parameters.
 *
 * @param real_name pointer to store the real name
 * @param real_email pointer to store the real email
 * @param mm the mailmap to perform a lookup with (may be NULL)
 * @param name the name to look up
 * @param email the email to look up
 * @return 0 on success, or an error code
 */
//GIT_EXTERN
int git_mailmap_resolve(const (char)** real_name, const (char)** real_email, const (libgit2_d.types.git_mailmap)* mm, const (char)* name, const (char)* email);

/**
 * Resolve a signature to use real names and emails with a mailmap.
 *
 * Call `git_signature_free()` to free the data.
 *
 * @param out_ new signature
 * @param mm mailmap to resolve with
 * @param sig signature to resolve
 * @return 0 or an error code
 */
//GIT_EXTERN
int git_mailmap_resolve_signature(libgit2_d.types.git_signature** out_, const (libgit2_d.types.git_mailmap)* mm, const (libgit2_d.types.git_signature)* sig);

/** @} */
