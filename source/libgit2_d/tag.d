/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.tag;


private static import libgit2_d.oid;
private static import libgit2_d.strarray;
private static import libgit2_d.types;

/*
 * @file git2/tag.h
 * @brief Git tag parsing routines
 * @defgroup git_tag Git tag management
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Lookup a tag object from the repository.
 *
 * Params:
 *      out_ = pointer to the looked up tag
 *      repo = the repo to use when locating the tag.
 *      id = identity of the tag to locate.
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_tag_lookup(libgit2_d.types.git_tag** out_, libgit2_d.types.git_repository* repo, const (libgit2_d.oid.git_oid)* id);

/**
 * Lookup a tag object from the repository,
 * given a prefix of its identifier (short id).
 *
 * @see git_object_lookup_prefix
 *
 * Params:
 *      out_ = pointer to the looked up tag
 *      repo = the repo to use when locating the tag.
 *      id = identity of the tag to locate.
 *      len = the length of the short identifier
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_tag_lookup_prefix(libgit2_d.types.git_tag** out_, libgit2_d.types.git_repository* repo, const (libgit2_d.oid.git_oid)* id, size_t len);

/**
 * Close an open tag
 *
 * You can no longer use the git_tag pointer after this call.
 *
 * IMPORTANT: You MUST call this method when you are through with a tag to
 * release memory. Failure to do so will cause a memory leak.
 *
 * Params:
 *      tag = the tag to close
 */
//GIT_EXTERN
void git_tag_free(libgit2_d.types.git_tag* tag);

/**
 * Get the id of a tag.
 *
 * Params:
 *      tag = a previously loaded tag.
 *
 * Returns: object identity for the tag.
 */
//GIT_EXTERN
const (libgit2_d.oid.git_oid)* git_tag_id(const (libgit2_d.types.git_tag)* tag);

/**
 * Get the repository that contains the tag.
 *
 * Params:
 *      tag = A previously loaded tag.
 *
 * Returns: Repository that contains this tag.
 */
//GIT_EXTERN
libgit2_d.types.git_repository* git_tag_owner(const (libgit2_d.types.git_tag)* tag);

/**
 * Get the tagged object of a tag
 *
 * This method performs a repository lookup for the
 * given object and returns it
 *
 * Params:
 *      target_out = pointer where to store the target
 *      tag = a previously loaded tag.
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_tag_target(libgit2_d.types.git_object** target_out, const (libgit2_d.types.git_tag)* tag);

/**
 * Get the OID of the tagged object of a tag
 *
 * Params:
 *      tag = a previously loaded tag.
 *
 * Returns: pointer to the OID
 */
//GIT_EXTERN
const (libgit2_d.oid.git_oid)* git_tag_target_id(const (libgit2_d.types.git_tag)* tag);

/**
 * Get the type of a tag's tagged object
 *
 * Params:
 *      tag = a previously loaded tag.
 *
 * Returns: type of the tagged object
 */
//GIT_EXTERN
libgit2_d.types.git_object_t git_tag_target_type(const (libgit2_d.types.git_tag)* tag);

/**
 * Get the name of a tag
 *
 * Params:
 *      tag = a previously loaded tag.
 *
 * Returns: name of the tag
 */
//GIT_EXTERN
const (char)* git_tag_name(const (libgit2_d.types.git_tag)* tag);

/**
 * Get the tagger (author) of a tag
 *
 * Params:
 *      tag = a previously loaded tag.
 *
 * Returns: reference to the tag's author or null when unspecified
 */
//GIT_EXTERN
const (libgit2_d.types.git_signature)* git_tag_tagger(const (libgit2_d.types.git_tag)* tag);

/**
 * Get the message of a tag
 *
 * Params:
 *      tag = a previously loaded tag.
 *
 * Returns: message of the tag or null when unspecified
 */
//GIT_EXTERN
const (char)* git_tag_message(const (libgit2_d.types.git_tag)* tag);

/**
 * Create a new tag in the repository from an object
 *
 * A new reference will also be created pointing to
 * this tag object. If `force` is true and a reference
 * already exists with the given name, it'll be replaced.
 *
 * The message will not be cleaned up. This can be achieved
 * through `git_message_prettify()`.
 *
 * The tag name will be checked for validity. You must avoid
 * the characters '~', '^', ':', '\\', '?', '[', and '*', and the
 * sequences ".." and "@{" which have special meaning to revparse.
 *
 * Params:
 *      oid = Pointer where to store the OID of the newly created tag. If the tag already exists, this parameter will be the oid of the existing tag, and the function will return a git_error_code.GIT_EEXISTS error code.
 *      repo = Repository where to store the tag
 *      tag_name = Name for the tag; this name is validated for consistency. It should also not conflict with an already existing tag name
 *      target = Object to which this tag points. This object must belong to the given `repo`.
 *      tagger = Signature of the tagger for this tag, and of the tagging time
 *      message = Full message for this tag
 *      force = Overwrite existing references
 *
 * Returns: 0 on success, git_error_code.GIT_EINVALIDSPEC or an error code A tag object is written to the ODB, and a proper reference is written in the /refs/tags folder, pointing to it
 */
//GIT_EXTERN
int git_tag_create(libgit2_d.oid.git_oid* oid, libgit2_d.types.git_repository* repo, const (char)* tag_name, const (libgit2_d.types.git_object)* target, const (libgit2_d.types.git_signature)* tagger, const (char)* message, int force);

/**
 * Create a new tag in the object database pointing to a git_object
 *
 * The message will not be cleaned up. This can be achieved
 * through `git_message_prettify()`.
 *
 * Params:
 *      oid = Pointer where to store the OID of the newly created tag
 *      repo = Repository where to store the tag
 *      tag_name = Name for the tag
 *      target = Object to which this tag points. This object must belong to the given `repo`.
 *      tagger = Signature of the tagger for this tag, and of the tagging time
 *      message = Full message for this tag
 *
 * Returns: 0 on success or an error code
 */
//GIT_EXTERN
int git_tag_annotation_create(libgit2_d.oid.git_oid* oid, libgit2_d.types.git_repository* repo, const (char)* tag_name, const (libgit2_d.types.git_object)* target, const (libgit2_d.types.git_signature)* tagger, const (char)* message);

/**
 * Create a new tag in the repository from a buffer
 *
 * Params:
 *      oid = Pointer where to store the OID of the newly created tag
 *      repo = Repository where to store the tag
 *      buffer = Raw tag data
 *      force = Overwrite existing tags
 *
 * Returns: 0 on success; error code otherwise
 */
//GIT_EXTERN
int git_tag_create_from_buffer(libgit2_d.oid.git_oid* oid, libgit2_d.types.git_repository* repo, const (char)* buffer, int force);

/**
 * Create a new lightweight tag pointing at a target object
 *
 * A new direct reference will be created pointing to
 * this target object. If `force` is true and a reference
 * already exists with the given name, it'll be replaced.
 *
 * The tag name will be checked for validity.
 * See `git_tag_create()` for rules about valid names.
 *
 * Params:
 *      oid = Pointer where to store the OID of the provided target object. If the tag already exists, this parameter will be filled with the oid of the existing pointed object and the function will return a git_error_code.GIT_EEXISTS error code.
 *      repo = Repository where to store the lightweight tag
 *      tag_name = Name for the tag; this name is validated for consistency. It should also not conflict with an already existing tag name
 *      target = Object to which this tag points. This object must belong to the given `repo`.
 *      force = Overwrite existing references
 *
 * Returns: 0 on success, git_error_code.GIT_EINVALIDSPEC or an error code A proper reference is written in the /refs/tags folder, pointing to the provided target object
 */
//GIT_EXTERN
int git_tag_create_lightweight(libgit2_d.oid.git_oid* oid, libgit2_d.types.git_repository* repo, const (char)* tag_name, const (libgit2_d.types.git_object)* target, int force);

/**
 * Delete an existing tag reference.
 *
 * The tag name will be checked for validity.
 * See `git_tag_create()` for rules about valid names.
 *
 * Params:
 *      repo = Repository where lives the tag
 *      tag_name = Name of the tag to be deleted; this name is validated for consistency.
 *
 * Returns: 0 on success, git_error_code.GIT_EINVALIDSPEC or an error code
 */
//GIT_EXTERN
int git_tag_delete(libgit2_d.types.git_repository* repo, const (char)* tag_name);

/**
 * Fill a list with all the tags in the Repository
 *
 * The string array will be filled with the names of the
 * matching tags; these values are owned by the user and
 * should be free'd manually when no longer needed, using
 * `git_strarray_free`.
 *
 * Params:
 *      tag_names = Pointer to a git_strarray structure where the tag names will be stored
 *      repo = Repository where to find the tags
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_tag_list(libgit2_d.strarray.git_strarray* tag_names, libgit2_d.types.git_repository* repo);

/**
 * Fill a list with all the tags in the Repository
 * which name match a defined pattern
 *
 * If an empty pattern is provided, all the tags
 * will be returned.
 *
 * The string array will be filled with the names of the
 * matching tags; these values are owned by the user and
 * should be free'd manually when no longer needed, using
 * `git_strarray_free`.
 *
 * Params:
 *      tag_names = Pointer to a git_strarray structure where the tag names will be stored
 *      pattern = Standard fnmatch pattern
 *      repo = Repository where to find the tags
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_tag_list_match(libgit2_d.strarray.git_strarray* tag_names, const (char)* pattern, libgit2_d.types.git_repository* repo);

/**
 * Callback used to iterate over tag names
 *
 * @see git_tag_foreach
 *
 * Returns: non-zero to terminate the iteration
 */
/*
 * Params:
 *      name = The tag name
 *      oid = The tag's OID
 *      payload = Payload passed to git_tag_foreach
 */
alias git_tag_foreach_cb = int function(const (char)* name, libgit2_d.oid.git_oid* oid, void* payload);

/**
 * Call callback `cb' for each tag in the repository
 *
 * Params:
 *      repo = Repository
 *      callback = Callback function
 *      payload = Pointer to callback data (optional)
 */
//GIT_EXTERN
int git_tag_foreach(libgit2_d.types.git_repository* repo, .git_tag_foreach_cb callback, void* payload);

/**
 * Recursively peel a tag until a non tag git_object is found
 *
 * The retrieved `tag_target` object is owned by the repository
 * and should be closed with the `git_object_free` method.
 *
 * Params:
 *      tag_target_out = Pointer to the peeled git_object
 *      tag = The tag to be processed
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_tag_peel(libgit2_d.types.git_object** tag_target_out, const (libgit2_d.types.git_tag)* tag);

/**
 * Create an in-memory copy of a tag. The copy must be explicitly
 * free'd or it will leak.
 *
 * Params:
 *      out_ = Pointer to store the copy of the tag
 *      source = Original tag to copy
 */
//GIT_EXTERN
int git_tag_dup(libgit2_d.types.git_tag** out_, libgit2_d.types.git_tag* source);

/* @} */
