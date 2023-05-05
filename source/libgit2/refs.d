/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.refs;


private static import libgit2.oid;
private static import libgit2.strarray;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/refs.h
 * @brief Git reference management routines
 * @defgroup git_reference Git reference management routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Lookup a reference by name in a repository.
 *
 * The returned reference must be freed by the user.
 *
 * The name will be checked for validity.
 * See `git_reference_symbolic_create()` for rules about valid names.
 *
 * Params:
 *      out_ = pointer to the looked-up reference
 *      repo = the repository to look up the reference
 *      name = the long name for the reference (e.g. HEAD, refs/heads/master, refs/tags/v0.1.0, ...)
 *
 * Returns: 0 on success, git_error_code.GIT_ENOTFOUND, git_error_code.GIT_EINVALIDSPEC or an error code.
 */
@GIT_EXTERN
int git_reference_lookup(libgit2.types.git_reference** out_, libgit2.types.git_repository* repo, const (char)* name);

/**
 * Lookup a reference by name and resolve immediately to OID.
 *
 * This function provides a quick way to resolve a reference name straight
 * through to the object id that it refers to.  This avoids having to
 * allocate or free any `git_reference` objects for simple situations.
 *
 * The name will be checked for validity.
 * See `git_reference_symbolic_create()` for rules about valid names.
 *
 * Params:
 *      out_ = Pointer to oid to be filled in
 *      repo = The repository in which to look up the reference
 *      name = The long name for the reference (e.g. HEAD, refs/heads/master, refs/tags/v0.1.0, ...)
 *
 * Returns: 0 on success, git_error_code.GIT_ENOTFOUND, git_error_code.GIT_EINVALIDSPEC or an error code.
 */
@GIT_EXTERN
int git_reference_name_to_id(libgit2.oid.git_oid* out_, libgit2.types.git_repository* repo, const (char)* name);

/**
 * Lookup a reference by DWIMing its short name
 *
 * Apply the git precendence rules to the given shorthand to determine
 * which reference the user is referring to.
 *
 * Params:
 *      out_ = pointer in which to store the reference
 *      repo = the repository in which to look
 *      shorthand = the short name for the reference
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_reference_dwim(libgit2.types.git_reference** out_, libgit2.types.git_repository* repo, const (char)* shorthand);

/**
 * Conditionally create a new symbolic reference.
 *
 * A symbolic reference is a reference name that refers to another
 * reference name.  If the other name moves, the symbolic name will move,
 * too.  As a simple example, the "HEAD" reference might refer to
 * "refs/heads/master" while on the "master" branch of a repository.
 *
 * The symbolic reference will be created in the repository and written to
 * the disk.  The generated reference object must be freed by the user.
 *
 * Valid reference names must follow one of two patterns:
 *
 * 1. Top-level names must contain only capital letters and underscores,
 *    and must begin and end with a letter. (e.g. "HEAD", "ORIG_HEAD").
 * 2. Names prefixed with "refs/" can be almost anything.  You must avoid
 *    the characters '~', '^', ':', '\\', '?', '[', and '*', and the
 *    sequences ".." and "@{" which have special meaning to revparse.
 *
 * This function will return an error if a reference already exists with the
 * given name unless `force` is true, in which case it will be overwritten.
 *
 * The message for the reflog will be ignored if the reference does
 * not belong in the standard set (HEAD, branches and remote-tracking
 * branches) and it does not have a reflog.
 *
 * It will return git_error_code.GIT_EMODIFIED if the reference's value at the time
 * of updating does not match the one passed through `current_value`
 * (i.e. if the ref has changed since the user read it).
 *
 * If `current_value` is all zeros, this function will return GIT_EMODIFIED
 * if the ref already exists.
 *
 * Params:
 *      out_ = Pointer to the newly created reference
 *      repo = Repository where that reference will live
 *      name = The name of the reference
 *      target = The target of the reference
 *      force = Overwrite existing references
 *      current_value = The expected value of the reference when updating
 *      log_message = The one line long message to be appended to the reflog
 *
 * Returns: 0 on success, git_error_code.GIT_EEXISTS, git_error_code.GIT_EINVALIDSPEC, git_error_code.GIT_EMODIFIED or an error code
 */
@GIT_EXTERN
int git_reference_symbolic_create_matching(libgit2.types.git_reference** out_, libgit2.types.git_repository* repo, const (char)* name, const (char)* target, int force, const (char)* current_value, const (char)* log_message);

/**
 * Create a new symbolic reference.
 *
 * A symbolic reference is a reference name that refers to another
 * reference name.  If the other name moves, the symbolic name will move,
 * too.  As a simple example, the "HEAD" reference might refer to
 * "refs/heads/master" while on the "master" branch of a repository.
 *
 * The symbolic reference will be created in the repository and written to
 * the disk.  The generated reference object must be freed by the user.
 *
 * Valid reference names must follow one of two patterns:
 *
 * 1. Top-level names must contain only capital letters and underscores,
 *    and must begin and end with a letter. (e.g. "HEAD", "ORIG_HEAD").
 * 2. Names prefixed with "refs/" can be almost anything.  You must avoid
 *    the characters '~', '^', ':', '\\', '?', '[', and '*', and the
 *    sequences ".." and "@{" which have special meaning to revparse.
 *
 * This function will return an error if a reference already exists with the
 * given name unless `force` is true, in which case it will be overwritten.
 *
 * The message for the reflog will be ignored if the reference does
 * not belong in the standard set (HEAD, branches and remote-tracking
 * branches) and it does not have a reflog.
 *
 * Params:
 *      out_ = Pointer to the newly created reference
 *      repo = Repository where that reference will live
 *      name = The name of the reference
 *      target = The target of the reference
 *      force = Overwrite existing references
 *      log_message = The one line long message to be appended to the reflog
 *
 * Returns: 0 on success, git_error_code.GIT_EEXISTS, git_error_code.GIT_EINVALIDSPEC or an error code
 */
@GIT_EXTERN
int git_reference_symbolic_create(libgit2.types.git_reference** out_, libgit2.types.git_repository* repo, const (char)* name, const (char)* target, int force, const (char)* log_message);

/**
 * Create a new direct reference.
 *
 * A direct reference (also called an object id reference) refers directly
 * to a specific object id (a.k.a. OID or SHA) in the repository.  The id
 * permanently refers to the object (although the reference itself can be
 * moved).  For example, in libgit2 the direct ref "refs/tags/v0.17.0"
 * refers to OID 5b9fac39d8a76b9139667c26a63e6b3f204b3977.
 *
 * The direct reference will be created in the repository and written to
 * the disk.  The generated reference object must be freed by the user.
 *
 * Valid reference names must follow one of two patterns:
 *
 * 1. Top-level names must contain only capital letters and underscores,
 *    and must begin and end with a letter. (e.g. "HEAD", "ORIG_HEAD").
 * 2. Names prefixed with "refs/" can be almost anything.  You must avoid
 *    the characters '~', '^', ':', '\\', '?', '[', and '*', and the
 *    sequences ".." and "@{" which have special meaning to revparse.
 *
 * This function will return an error if a reference already exists with the
 * given name unless `force` is true, in which case it will be overwritten.
 *
 * The message for the reflog will be ignored if the reference does
 * not belong in the standard set (HEAD, branches and remote-tracking
 * branches) and it does not have a reflog.
 *
 * Params:
 *      out_ = Pointer to the newly created reference
 *      repo = Repository where that reference will live
 *      name = The name of the reference
 *      id = The object id pointed to by the reference.
 *      force = Overwrite existing references
 *      log_message = The one line long message to be appended to the reflog
 *
 * Returns: 0 on success, git_error_code.GIT_EEXISTS, git_error_code.GIT_EINVALIDSPEC or an error code
 */
@GIT_EXTERN
int git_reference_create(libgit2.types.git_reference** out_, libgit2.types.git_repository* repo, const (char)* name, const (libgit2.oid.git_oid)* id, int force, const (char)* log_message);

/**
 * Conditionally create new direct reference
 *
 * A direct reference (also called an object id reference) refers directly
 * to a specific object id (a.k.a. OID or SHA) in the repository.  The id
 * permanently refers to the object (although the reference itself can be
 * moved).  For example, in libgit2 the direct ref "refs/tags/v0.17.0"
 * refers to OID 5b9fac39d8a76b9139667c26a63e6b3f204b3977.
 *
 * The direct reference will be created in the repository and written to
 * the disk.  The generated reference object must be freed by the user.
 *
 * Valid reference names must follow one of two patterns:
 *
 * 1. Top-level names must contain only capital letters and underscores,
 *    and must begin and end with a letter. (e.g. "HEAD", "ORIG_HEAD").
 * 2. Names prefixed with "refs/" can be almost anything.  You must avoid
 *    the characters '~', '^', ':', '\\', '?', '[', and '*', and the
 *    sequences ".." and "@{" which have special meaning to revparse.
 *
 * This function will return an error if a reference already exists with the
 * given name unless `force` is true, in which case it will be overwritten.
 *
 * The message for the reflog will be ignored if the reference does
 * not belong in the standard set (HEAD, branches and remote-tracking
 * branches) and it does not have a reflog.
 *
 * It will return git_error_code.GIT_EMODIFIED if the reference's value at the time
 * of updating does not match the one passed through `current_id`
 * (i.e. if the ref has changed since the user read it).
 *
 * Params:
 *      out_ = Pointer to the newly created reference
 *      repo = Repository where that reference will live
 *      name = The name of the reference
 *      id = The object id pointed to by the reference.
 *      force = Overwrite existing references
 *      current_id = The expected value of the reference at the time of update
 *      log_message = The one line long message to be appended to the reflog
 *
 * Returns: 0 on success, git_error_code.GIT_EMODIFIED if the value of the reference has changed, git_error_code.GIT_EEXISTS, git_error_code.GIT_EINVALIDSPEC or an error code
 */
@GIT_EXTERN
int git_reference_create_matching(libgit2.types.git_reference** out_, libgit2.types.git_repository* repo, const (char)* name, const (libgit2.oid.git_oid)* id, int force, const (libgit2.oid.git_oid)* current_id, const (char)* log_message);

/**
 * Get the OID pointed to by a direct reference.
 *
 * Only available if the reference is direct (i.e. an object id reference,
 * not a symbolic one).
 *
 * To find the OID of a symbolic ref, call `git_reference_resolve()` and
 * then this function (or maybe use `git_reference_name_to_id()` to
 * directly resolve a reference name all the way through to an OID).
 *
 * Params:
 *      ref_ = The reference
 *
 * Returns: a pointer to the oid if available, null otherwise
 */
@GIT_EXTERN
const (libgit2.oid.git_oid)* git_reference_target(const (libgit2.types.git_reference)* ref_);

/**
 * Return the peeled OID target of this reference.
 *
 * This peeled OID only applies to direct references that point to
 * a hard Tag object: it is the result of peeling such Tag.
 *
 * Params:
 *      ref_ = The reference
 *
 * Returns: a pointer to the oid if available, null otherwise
 */
@GIT_EXTERN
const (libgit2.oid.git_oid)* git_reference_target_peel(const (libgit2.types.git_reference)* ref_);

/**
 * Get full name to the reference pointed to by a symbolic reference.
 *
 * Only available if the reference is symbolic.
 *
 * Params:
 *      ref_ = The reference
 *
 * Returns: a pointer to the name if available, null otherwise
 */
@GIT_EXTERN
const (char)* git_reference_symbolic_target(const (libgit2.types.git_reference)* ref_);

/**
 * Get the type of a reference.
 *
 * Either direct (git_reference_t.GIT_REFERENCE_DIRECT) or symbolic (git_reference_t.GIT_REFERENCE_SYMBOLIC)
 *
 * Params:
 *      ref_ = The reference
 *
 * Returns: the type
 */
@GIT_EXTERN
libgit2.types.git_reference_t git_reference_type(const (libgit2.types.git_reference)* ref_);

/**
 * Get the full name of a reference.
 *
 * See `git_reference_symbolic_create()` for rules about valid names.
 *
 * Params:
 *      ref_ = The reference
 *
 * Returns: the full name for the ref_
 */
@GIT_EXTERN
const (char)* git_reference_name(const (libgit2.types.git_reference)* ref_);

/**
 * Resolve a symbolic reference to a direct reference.
 *
 * This method iteratively peels a symbolic reference until it resolves to
 * a direct reference to an OID.
 *
 * The peeled reference is returned in the `resolved_ref` argument, and
 * must be freed manually once it's no longer needed.
 *
 * If a direct reference is passed as an argument, a copy of that
 * reference is returned. This copy must be manually freed too.
 *
 * Params:
 *      out_ = Pointer to the peeled reference
 *      ref_ = The reference
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_reference_resolve(libgit2.types.git_reference** out_, const (libgit2.types.git_reference)* ref_);

/**
 * Get the repository where a reference resides.
 *
 * Params:
 *      ref_ = The reference
 *
 * Returns: a pointer to the repo
 */
@GIT_EXTERN
libgit2.types.git_repository* git_reference_owner(const (libgit2.types.git_reference)* ref_);

/**
 * Create a new reference with the same name as the given reference but a
 * different symbolic target. The reference must be a symbolic reference,
 * otherwise this will fail.
 *
 * The new reference will be written to disk, overwriting the given reference.
 *
 * The target name will be checked for validity.
 * See `git_reference_symbolic_create()` for rules about valid names.
 *
 * The message for the reflog will be ignored if the reference does
 * not belong in the standard set (HEAD, branches and remote-tracking
 * branches) and it does not have a reflog.
 *
 * Params:
 *      out_ = Pointer to the newly created reference
 *      ref_ = The reference
 *      target = The new target for the reference
 *      log_message = The one line long message to be appended to the reflog
 *
 * Returns: 0 on success, git_error_code.GIT_EINVALIDSPEC or an error code
 */
@GIT_EXTERN
int git_reference_symbolic_set_target(libgit2.types.git_reference** out_, libgit2.types.git_reference* ref_, const (char)* target, const (char)* log_message);

/**
 * Conditionally create a new reference with the same name as the given
 * reference but a different OID target. The reference must be a direct
 * reference, otherwise this will fail.
 *
 * The new reference will be written to disk, overwriting the given reference.
 *
 * Params:
 *      out_ = Pointer to the newly created reference
 *      ref_ = The reference
 *      id = The new target OID for the reference
 *      log_message = The one line long message to be appended to the reflog
 *
 * Returns: 0 on success, git_error_code.GIT_EMODIFIED if the value of the reference has changed since it was read, or an error code
 */
@GIT_EXTERN
int git_reference_set_target(libgit2.types.git_reference** out_, libgit2.types.git_reference* ref_, const (libgit2.oid.git_oid)* id, const (char)* log_message);

/**
 * Rename an existing reference.
 *
 * This method works for both direct and symbolic references.
 *
 * The new name will be checked for validity.
 * See `git_reference_symbolic_create()` for rules about valid names.
 *
 * If the `force` flag is not enabled, and there's already
 * a reference with the given name, the renaming will fail.
 *
 * IMPORTANT:
 * The user needs to write a proper reflog entry if the
 * reflog is enabled for the repository. We only rename
 * the reflog if it exists.
 *
 * Params:
 *      new_ref = ?
 *      ref_ = The reference to rename
 *      new_name = The new name for the reference
 *      force = Overwrite an existing reference
 *      log_message = The one line long message to be appended to the reflog
 *
 * Returns: 0 on success, git_error_code.GIT_EINVALIDSPEC, git_error_code.GIT_EEXISTS or an error code
 *
 */
@GIT_EXTERN
int git_reference_rename(libgit2.types.git_reference** new_ref, libgit2.types.git_reference* ref_, const (char)* new_name, int force, const (char)* log_message);

/**
 * Delete an existing reference.
 *
 * This method works for both direct and symbolic references.  The reference
 * will be immediately removed on disk but the memory will not be freed.
 * Callers must call `git_reference_free`.
 *
 * This function will return an error if the reference has changed
 * from the time it was looked up.
 *
 * Params:
 *      ref_ = The reference to remove
 *
 * Returns: 0, git_error_code.GIT_EMODIFIED or an error code
 */
@GIT_EXTERN
int git_reference_delete(libgit2.types.git_reference* ref_);

/**
 * Delete an existing reference by name
 *
 * This method removes the named reference from the repository without
 * looking at its old value.
 *
 * Params:
 *      repo = ?
 *      name = The reference to remove
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_reference_remove(libgit2.types.git_repository* repo, const (char)* name);

/**
 * Fill a list with all the references that can be found in a repository.
 *
 * The string array will be filled with the names of all references; these
 * values are owned by the user and should be free'd manually when no
 * longer needed, using `git_strarray_free()`.
 *
 * Params:
 *      array = Pointer to a git_strarray structure where the reference names will be stored
 *      repo = Repository where to find the refs
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_reference_list(libgit2.strarray.git_strarray* array, libgit2.types.git_repository* repo);

/**
 * Callback used to iterate over references
 *
 * @see git_reference_foreach
 *
 * Returns: non-zero to terminate the iteration
 */
/*
 * Params:
 *      reference = The reference object
 *      payload = Payload passed to git_reference_foreach
 */
alias git_reference_foreach_cb = int function(libgit2.types.git_reference* reference, void* payload);

/**
 * Callback used to iterate over reference names
 *
 * @see git_reference_foreach_name
 *
 * Returns: non-zero to terminate the iteration
 */
/*
 * Params:
 *      name = The reference name
 *      payload = Payload passed to git_reference_foreach_name
 */
alias git_reference_foreach_name_cb = int function(const (char)* name, void* payload);

/**
 * Perform a callback on each reference in the repository.
 *
 * The `callback` function will be called for each reference in the
 * repository, receiving the reference object and the `payload` value
 * passed to this method.  Returning a non-zero value from the callback
 * will terminate the iteration.
 *
 * Note that the callback function is responsible to call `git_reference_free`
 * on each reference passed to it.
 *
 * Params:
 *      repo = Repository where to find the refs
 *      callback = Function which will be called for every listed ref
 *      payload = Additional data to pass to the callback
 *
 * Returns: 0 on success, non-zero callback return value, or error code
 */
@GIT_EXTERN
int git_reference_foreach(libgit2.types.git_repository* repo, .git_reference_foreach_cb callback, void* payload);

/**
 * Perform a callback on the fully-qualified name of each reference.
 *
 * The `callback` function will be called for each reference in the
 * repository, receiving the name of the reference and the `payload` value
 * passed to this method.  Returning a non-zero value from the callback
 * will terminate the iteration.
 *
 * Params:
 *      repo = Repository where to find the refs
 *      callback = Function which will be called for every listed ref name
 *      payload = Additional data to pass to the callback
 *
 * Returns: 0 on success, non-zero callback return value, or error code
 */
@GIT_EXTERN
int git_reference_foreach_name(libgit2.types.git_repository* repo, git_reference_foreach_name_cb callback, void* payload);

/**
 * Create a copy of an existing reference.
 *
 * Call `git_reference_free` to free the data.
 *
 * Params:
 *      dest = pointer where to store the copy
 *      source = object to copy
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_reference_dup(libgit2.types.git_reference** dest, libgit2.types.git_reference* source);

/**
 * Free the given reference.
 *
 * Params:
 *      ref_ = git_reference
 */
@GIT_EXTERN
void git_reference_free(libgit2.types.git_reference* ref_);

/**
 * Compare two references.
 *
 * Params:
 *      ref1 = The first git_reference
 *      ref2 = The second git_reference
 *
 * Returns: 0 if the same, else a stable but meaningless ordering.
 */
@GIT_EXTERN
int git_reference_cmp(const (libgit2.types.git_reference)* ref1, const (libgit2.types.git_reference)* ref2);

/**
 * Create an iterator for the repo's references
 *
 * Params:
 *      out_ = pointer in which to store the iterator
 *      repo = the repository
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_reference_iterator_new(libgit2.types.git_reference_iterator** out_, libgit2.types.git_repository* repo);

/**
 * Create an iterator for the repo's references that match the
 * specified glob
 *
 * Params:
 *      out_ = pointer in which to store the iterator
 *      repo = the repository
 *      glob = the glob to match against the reference names
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_reference_iterator_glob_new(libgit2.types.git_reference_iterator** out_, libgit2.types.git_repository* repo, const (char)* glob);

/**
 * Get the next reference
 *
 * Params:
 *      out_ = pointer in which to store the reference
 *      iter = the iterator
 *
 * Returns: 0, git_error_code.GIT_ITEROVER if there are no more; or an error code
 */
@GIT_EXTERN
int git_reference_next(libgit2.types.git_reference** out_, libgit2.types.git_reference_iterator* iter);

/**
 * Get the next reference's name
 *
 * This function is provided for convenience in case only the names
 * are interesting as it avoids the allocation of the `git_reference`
 * object which `git_reference_next()` needs.
 *
 * Params:
 *      out_ = pointer in which to store the string
 *      iter = the iterator
 *
 * Returns: 0, git_error_code.GIT_ITEROVER if there are no more; or an error code
 */
@GIT_EXTERN
int git_reference_next_name(const (char)** out_, libgit2.types.git_reference_iterator* iter);

/**
 * Free the iterator and its associated resources
 *
 * Params:
 *      iter = the iterator to free
 */
@GIT_EXTERN
void git_reference_iterator_free(libgit2.types.git_reference_iterator* iter);

/**
 * Perform a callback on each reference in the repository whose name
 * matches the given pattern.
 *
 * This function acts like `git_reference_foreach()` with an additional
 * pattern match being applied to the reference name before issuing the
 * callback function.  See that function for more information.
 *
 * The pattern is matched using fnmatch or "glob" style where a '*' matches
 * any sequence of letters, a '?' matches any letter, and square brackets
 * can be used to define character ranges (such as "[0-9]" for digits).
 *
 * Params:
 *      repo = Repository where to find the refs
 *      glob = Pattern to match (fnmatch-style) against reference name.
 *      callback = Function which will be called for every listed ref
 *      payload = Additional data to pass to the callback
 *
 * Returns: 0 on success, git_error_code.GIT_EUSER on non-zero callback, or error code
 */
@GIT_EXTERN
int git_reference_foreach_glob(libgit2.types.git_repository* repo, const (char)* glob, git_reference_foreach_name_cb callback, void* payload);

/**
 * Check if a reflog exists for the specified reference.
 *
 * Params:
 *      repo = the repository
 *      refname = the reference's name
 *
 * Returns: 0 when no reflog can be found, 1 when it exists; otherwise an error code.
 */
@GIT_EXTERN
int git_reference_has_log(libgit2.types.git_repository* repo, const (char)* refname);

/**
 * Ensure there is a reflog for a particular reference.
 *
 * Make sure that successive updates to the reference will append to
 * its log.
 *
 * Params:
 *      repo = the repository
 *      refname = the reference's name
 *
 * Returns: 0 or an error code.
 */
@GIT_EXTERN
int git_reference_ensure_log(libgit2.types.git_repository* repo, const (char)* refname);

/**
 * Check if a reference is a local branch.
 *
 * Params:
 *      ref_ = A git reference
 *
 * Returns: 1 when the reference lives in the refs/heads namespace; 0 otherwise.
 */
@GIT_EXTERN
int git_reference_is_branch(const (libgit2.types.git_reference)* ref_);

/**
 * Check if a reference is a remote tracking branch
 *
 * Params:
 *      ref_ = A git reference
 *
 * Returns: 1 when the reference lives in the refs/remotes namespace; 0 otherwise.
 */
@GIT_EXTERN
int git_reference_is_remote(const (libgit2.types.git_reference)* ref_);

/**
 * Check if a reference is a tag
 *
 * Params:
 *      ref_ = A git reference
 *
 * Returns: 1 when the reference lives in the refs/tags namespace; 0 otherwise.
 */
@GIT_EXTERN
int git_reference_is_tag(const (libgit2.types.git_reference)* ref_);

/**
 * Check if a reference is a note
 *
 * Params:
 *      ref_ = A git reference
 *
 * Returns: 1 when the reference lives in the refs/notes namespace; 0 otherwise.
 */
@GIT_EXTERN
int git_reference_is_note(const (libgit2.types.git_reference)* ref_);

/**
 * Normalization options for reference lookup
 */
enum git_reference_format_t
{
	/**
	 * No particular normalization.
	 */
	GIT_REFERENCE_FORMAT_NORMAL = 0u,

	/**
	 * Control whether one-level refnames are accepted
	 * (i.e., refnames that do not contain multiple /-separated
	 * components). Those are expected to be written only using
	 * uppercase letters and underscore (FETCH_HEAD, ...)
	 */
	GIT_REFERENCE_FORMAT_ALLOW_ONELEVEL = 1u << 0,

	/**
	 * Interpret the provided name as a reference pattern for a
	 * refspec (as used with remote repositories). If this option
	 * is enabled, the name is allowed to contain a single * (<star>)
	 * in place of a one full pathname component
	 * (e.g., foo/<star>/bar but not foo/bar<star>).
	 */
	GIT_REFERENCE_FORMAT_REFSPEC_PATTERN = 1u << 1,

	/**
	 * Interpret the name as part of a refspec in shorthand form
	 * so the `ONELEVEL` naming rules aren't enforced and 'master'
	 * becomes a valid name.
	 */
	GIT_REFERENCE_FORMAT_REFSPEC_SHORTHAND = 1u << 2,
}

//Declaration name in C language
enum
{
	GIT_REFERENCE_FORMAT_NORMAL = .git_reference_format_t.GIT_REFERENCE_FORMAT_NORMAL,
	GIT_REFERENCE_FORMAT_ALLOW_ONELEVEL = .git_reference_format_t.GIT_REFERENCE_FORMAT_ALLOW_ONELEVEL,
	GIT_REFERENCE_FORMAT_REFSPEC_PATTERN = .git_reference_format_t.GIT_REFERENCE_FORMAT_REFSPEC_PATTERN,
	GIT_REFERENCE_FORMAT_REFSPEC_SHORTHAND = .git_reference_format_t.GIT_REFERENCE_FORMAT_REFSPEC_SHORTHAND,
}

/**
 * Normalize reference name and check validity.
 *
 * This will normalize the reference name by removing any leading slash
 * '/' characters and collapsing runs of adjacent slashes between name
 * components into a single slash.
 *
 * Once normalized, if the reference name is valid, it will be returned in
 * the user allocated buffer.
 *
 * See `git_reference_symbolic_create()` for rules about valid names.
 *
 * Params:
 *      buffer_out = User allocated buffer to store normalized name
 *      buffer_size = Size of buffer_out
 *      name = Reference name to be checked.
 *      flags = Flags to constrain name validation rules - see the GIT_REFERENCE_FORMAT constants above.
 *
 * Returns: 0 on success, git_error_code.GIT_EBUFS if buffer is too small, git_error_code.GIT_EINVALIDSPEC or an error code.
 */
@GIT_EXTERN
int git_reference_normalize_name(char* buffer_out, size_t buffer_size, const (char)* name, uint flags);

/**
 * Recursively peel reference until object of the specified type is found.
 *
 * The retrieved `peeled` object is owned by the repository
 * and should be closed with the `git_object_free` method.
 *
 * If you pass `git_object_t.GIT_OBJECT_ANY` as the target type, then the object
 * will be peeled until a non-tag object is met.
 *
 * Params:
 *      out_ = Pointer to the peeled git_object
 *      ref_ = The reference to be processed
 *      type = The type of the requested object (git_object_t.GIT_OBJECT_COMMIT, git_object_t.GIT_OBJECT_TAG, git_object_t.GIT_OBJECT_TREE, git_object_t.GIT_OBJECT_BLOB or git_object_t.GIT_OBJECT_ANY).
 *
 * Returns: 0 on success, git_error_code.GIT_EAMBIGUOUS, git_error_code.GIT_ENOTFOUND or an error code
 */
@GIT_EXTERN
int git_reference_peel(libgit2.types.git_object** out_, const (libgit2.types.git_reference)* ref_, libgit2.types.git_object_t type);

/**
 * Ensure the reference name is well-formed.
 *
 * Valid reference names must follow one of two patterns:
 *
 * 1. Top-level names must contain only capital letters and underscores,
 *    and must begin and end with a letter. (e.g. "HEAD", "ORIG_HEAD").
 * 2. Names prefixed with "refs/" can be almost anything.  You must avoid
 *    the characters '~', '^', ':', '\\', '?', '[', and '*', and the
 *    sequences ".." and "@{" which have special meaning to revparse.
 *
 * Params:
 *      valid = output pointer to set with validity of given reference name
 *      refname = name to be checked.
 *
 * Returns: 0 on success or an error code
 */
@GIT_EXTERN
int git_reference_name_is_valid(int* valid, const (char)* refname);

/**
 * Get the reference's short name
 *
 * This will transform the reference name into a name "human-readable"
 * version. If no shortname is appropriate, it will return the full
 * name.
 *
 * The memory is owned by the reference and must not be freed.
 *
 * Params:
 *      ref_ = a reference
 *
 * Returns: the human-readable version of the name
 */
@GIT_EXTERN
const (char)* git_reference_shorthand(const (libgit2.types.git_reference)* ref_);

/* @} */
