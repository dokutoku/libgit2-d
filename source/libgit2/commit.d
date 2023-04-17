/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2.commit;


private static import libgit2.buffer;
private static import libgit2.oid;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/commit.h
 * @brief Git commit parsing, formatting routines
 * @defgroup git_commit Git commit parsing, formatting routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Lookup a commit object from a repository.
 *
 * The returned object should be released with `git_commit_free` when no
 * longer needed.
 *
 * Params:
 *      commit = pointer to the looked up commit
 *      repo = the repo to use when locating the commit.
 *      id = identity of the commit to locate. If the object is an annotated tag it will be peeled back to the commit.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_commit_lookup(libgit2.types.git_commit** commit, libgit2.types.git_repository* repo, const (libgit2.oid.git_oid)* id);

/**
 * Lookup a commit object from a repository, given a prefix of its
 * identifier (short id).
 *
 * The returned object should be released with `git_commit_free` when no
 * longer needed.
 *
 * @see git_object_lookup_prefix
 *
 * Params:
 *      commit = pointer to the looked up commit
 *      repo = the repo to use when locating the commit.
 *      id = identity of the commit to locate. If the object is an annotated tag it will be peeled back to the commit.
 *      len = the length of the short identifier
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_commit_lookup_prefix(libgit2.types.git_commit** commit, libgit2.types.git_repository* repo, const (libgit2.oid.git_oid)* id, size_t len);

/**
 * Close an open commit
 *
 * This is a wrapper around git_object_free()
 *
 * IMPORTANT:
 * It *is* necessary to call this method when you stop
 * using a commit. Failure to do so will cause a memory leak.
 *
 * Params:
 *      commit = the commit to close
 */

@GIT_EXTERN
void git_commit_free(libgit2.types.git_commit* commit);

/**
 * Get the id of a commit.
 *
 * Params:
 *      commit = a previously loaded commit.
 *
 * Returns: object identity for the commit.
 */
@GIT_EXTERN
const (libgit2.oid.git_oid)* git_commit_id(const (libgit2.types.git_commit)* commit);

/**
 * Get the repository that contains the commit.
 *
 * Params:
 *      commit = A previously loaded commit.
 *
 * Returns: Repository that contains this commit.
 */
@GIT_EXTERN
libgit2.types.git_repository* git_commit_owner(const (libgit2.types.git_commit)* commit);

/**
 * Get the encoding for the message of a commit,
 * as a string representing a standard encoding name.
 *
 * The encoding may be null if the `encoding` header
 * in the commit is missing; in that case UTF-8 is assumed.
 *
 * Params:
 *      commit = a previously loaded commit.
 *
 * Returns: null, or the encoding
 */
@GIT_EXTERN
const (char)* git_commit_message_encoding(const (libgit2.types.git_commit)* commit);

/**
 * Get the full message of a commit.
 *
 * The returned message will be slightly prettified by removing any
 * potential leading newlines.
 *
 * Params:
 *      commit = a previously loaded commit.
 *
 * Returns: the message of a commit
 */
@GIT_EXTERN
const (char)* git_commit_message(const (libgit2.types.git_commit)* commit);

/**
 * Get the full raw message of a commit.
 *
 * Params:
 *      commit = a previously loaded commit.
 *
 * Returns: the raw message of a commit
 */
@GIT_EXTERN
const (char)* git_commit_message_raw(const (libgit2.types.git_commit)* commit);

/**
 * Get the short "summary" of the git commit message.
 *
 * The returned message is the summary of the commit, comprising the
 * first paragraph of the message with whitespace trimmed and squashed.
 *
 * Params:
 *      commit = a previously loaded commit.
 *
 * Returns: the summary of a commit or null on error
 */
@GIT_EXTERN
const (char)* git_commit_summary(libgit2.types.git_commit* commit);

/**
 * Get the long "body" of the git commit message.
 *
 * The returned message is the body of the commit, comprising
 * everything but the first paragraph of the message. Leading and
 * trailing whitespaces are trimmed.
 *
 * Params:
 *      commit = a previously loaded commit.
 *
 * Returns: the body of a commit or null when no the message only consists of a summary
 */
@GIT_EXTERN
const (char)* git_commit_body(libgit2.types.git_commit* commit);

/**
 * Get the commit time (i.e. committer time) of a commit.
 *
 * Params:
 *      commit = a previously loaded commit.
 *
 * Returns: the time of a commit
 */
@GIT_EXTERN
libgit2.types.git_time_t git_commit_time(const (libgit2.types.git_commit)* commit);

/**
 * Get the commit timezone offset (i.e. committer's preferred timezone) of a
 * commit.
 *
 * Params:
 *      commit = a previously loaded commit.
 *
 * Returns: positive or negative timezone offset, in minutes from UTC
 */
@GIT_EXTERN
int git_commit_time_offset(const (libgit2.types.git_commit)* commit);

/**
 * Get the committer of a commit.
 *
 * Params:
 *      commit = a previously loaded commit.
 *
 * Returns: the committer of a commit
 */
@GIT_EXTERN
const (libgit2.types.git_signature)* git_commit_committer(const (libgit2.types.git_commit)* commit);

/**
 * Get the author of a commit.
 *
 * Params:
 *      commit = a previously loaded commit.
 *
 * Returns: the author of a commit
 */
@GIT_EXTERN
const (libgit2.types.git_signature)* git_commit_author(const (libgit2.types.git_commit)* commit);

/**
 * Get the committer of a commit, using the mailmap to map names and email
 * addresses to canonical real names and email addresses.
 *
 * Call `git_signature_free` to free the signature.
 *
 * Params:
 *      out_ = a pointer to store the resolved signature.
 *      commit = a previously loaded commit.
 *      mailmap = the mailmap to resolve with. (may be NULL)
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_commit_committer_with_mailmap(libgit2.types.git_signature** out_, const (libgit2.types.git_commit)* commit, const (libgit2.types.git_mailmap)* mailmap);

/**
 * Get the author of a commit, using the mailmap to map names and email
 * addresses to canonical real names and email addresses.
 *
 * Call `git_signature_free` to free the signature.
 *
 * Params:
 *      out_ = a pointer to store the resolved signature.
 *      commit = a previously loaded commit.
 *      mailmap = the mailmap to resolve with. (may be NULL)
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_commit_author_with_mailmap(libgit2.types.git_signature** out_, const (libgit2.types.git_commit)* commit, const (libgit2.types.git_mailmap)* mailmap);

/**
 * Get the full raw text of the commit header.
 *
 * Params:
 *      commit = a previously loaded commit
 *
 * Returns: the header text of the commit
 */
@GIT_EXTERN
const (char)* git_commit_raw_header(const (libgit2.types.git_commit)* commit);

/**
 * Get the tree pointed to by a commit.
 *
 * Params:
 *      tree_out = pointer where to store the tree object
 *      commit = a previously loaded commit.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_commit_tree(libgit2.types.git_tree** tree_out, const (libgit2.types.git_commit)* commit);

/**
 * Get the id of the tree pointed to by a commit. This differs from
 * `git_commit_tree` in that no attempts are made to fetch an object
 * from the ODB.
 *
 * Params:
 *      commit = a previously loaded commit.
 *
 * Returns: the id of tree pointed to by commit.
 */
@GIT_EXTERN
const (libgit2.oid.git_oid)* git_commit_tree_id(const (libgit2.types.git_commit)* commit);

/**
 * Get the number of parents of this commit
 *
 * Params:
 *      commit = a previously loaded commit.
 *
 * Returns: integer of count of parents
 */
@GIT_EXTERN
uint git_commit_parentcount(const (libgit2.types.git_commit)* commit);

/**
 * Get the specified parent of the commit.
 *
 * Params:
 *      out_ = Pointer where to store the parent commit
 *      commit = a previously loaded commit.
 *      n = the position of the parent (from 0 to `parentcount`)
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_commit_parent(libgit2.types.git_commit** out_, const (libgit2.types.git_commit)* commit, uint n);

/**
 * Get the oid of a specified parent for a commit. This is different from
 * `git_commit_parent`, which will attempt to load the parent commit from
 * the ODB.
 *
 * Params:
 *      commit = a previously loaded commit.
 *      n = the position of the parent (from 0 to `parentcount`)
 *
 * Returns: the id of the parent, null on error.
 */
@GIT_EXTERN
const (libgit2.oid.git_oid)* git_commit_parent_id(const (libgit2.types.git_commit)* commit, uint n);

/**
 * Get the commit object that is the <n>th generation ancestor
 * of the named commit object, following only the first parents.
 * The returned commit has to be freed by the caller.
 *
 * Passing `0` as the generation number returns another instance of the
 * base commit itself.
 *
 * Params:
 *      ancestor = Pointer where to store the ancestor commit
 *      commit = a previously loaded commit.
 *      n = the requested generation
 *
 * Returns: 0 on success; git_error_code.GIT_ENOTFOUND if no matching ancestor exists or an error code
 */
@GIT_EXTERN
int git_commit_nth_gen_ancestor(libgit2.types.git_commit** ancestor, const (libgit2.types.git_commit)* commit, uint n);

/**
 * Get an arbitrary header field
 *
 * Params:
 *      out_ = the buffer to fill; existing content will be overwritten
 *      commit = the commit to look in
 *      field = the header field to return
 *
 * Returns: 0 on succeess, git_error_code.GIT_ENOTFOUND if the field does not exist, or an error code
 */
@GIT_EXTERN
int git_commit_header_field(libgit2.buffer.git_buf* out_, const (libgit2.types.git_commit)* commit, const (char)* field);

/**
 * Extract the signature from a commit
 *
 * If the id is not for a commit, the error class will be
 * `git_error_t.GIT_ERROR_INVALID`. If the commit does not have a signature, the
 * error class will be `git_error_t.GIT_ERROR_OBJECT`.
 *
 * Params:
 *      signature = the signature block; existing content will be overwritten
 *      signed_data = signed data; this is the commit contents minus the signature block; existing content will be overwritten
 *      repo = the repository in which the commit exists
 *      commit_id = the commit from which to extract the data
 *      field = the name of the header field containing the signature block; pass `null` to extract the default 'gpgsig'
 *
 * Returns: 0 on success, git_error_code.GIT_ENOTFOUND if the id is not for a commit or the commit does not have a signature.
 */
@GIT_EXTERN
int git_commit_extract_signature(libgit2.buffer.git_buf* signature, libgit2.buffer.git_buf* signed_data, libgit2.types.git_repository* repo, libgit2.oid.git_oid* commit_id, const (char)* field);

/**
 * Create new commit in the repository from a list of `git_object` pointers
 *
 * The message will **not** be cleaned up automatically. You can do that
 * with the `git_message_prettify()` function.
 *
 * Params:
 *      id = Pointer in which to store the OID of the newly created commit
 *      repo = Repository where to store the commit
 *      update_ref = If not null, name of the reference that will be updated to point to this commit. If the reference is not direct, it will be resolved to a direct reference. Use "HEAD" to update the HEAD of the current branch and make it point to this commit. If the reference doesn't exist yet, it will be created. If it does exist, the first parent must be the tip of this branch.
 *      author = Signature with author and author time of commit
 *      committer = Signature with committer and * commit time of commit
 *      message_encoding = The encoding for the message in the commit, represented with a standard encoding name. E.g. "UTF-8". If null, no encoding header is written and UTF-8 is assumed.
 *      message = Full message for this commit
 *      tree = An instance of a `git_tree` object that will be used as the tree for the commit. This tree object must also be owned by the given `repo`.
 *      parent_count = Number of parents for this commit
 *      parents = Array of `parent_count` pointers to `git_commit` objects that will be used as the parents for this commit. This array may be null if `parent_count` is 0 (root commit). All the given commits must be owned by the `repo`.
 *
 * Returns: 0 or an error code. The created commit will be written to the Object Database and the given reference will be updated to point to it
 */
@GIT_EXTERN
int git_commit_create(libgit2.oid.git_oid* id, libgit2.types.git_repository* repo, const (char)* update_ref, const (libgit2.types.git_signature)* author, const (libgit2.types.git_signature)* committer, const (char)* message_encoding, const (char)* message, const (libgit2.types.git_tree)* tree, size_t parent_count, const (libgit2.types.git_commit)** parents);

/**
 * Create new commit in the repository using a variable argument list.
 *
 * The message will **not** be cleaned up automatically. You can do that
 * with the `git_message_prettify()` function.
 *
 * The parents for the commit are specified as a variable list of pointers
 * to `const git_commit *`. Note that this is a convenience method which may
 * not be safe to export for certain languages or compilers
 *
 * All other parameters remain the same as `git_commit_create()`.
 *
 * @see git_commit_create
 */
@GIT_EXTERN
int git_commit_create_v(libgit2.oid.git_oid* id, libgit2.types.git_repository* repo, const (char)* update_ref, const (libgit2.types.git_signature)* author, const (libgit2.types.git_signature)* committer, const (char)* message_encoding, const (char)* message, const (libgit2.types.git_tree)* tree, size_t parent_count, ...);

/**
 * Amend an existing commit by replacing only non-null values.
 *
 * This creates a new commit that is exactly the same as the old commit,
 * except that any non-null values will be updated.  The new commit has
 * the same parents as the old commit.
 *
 * The `update_ref` value works as in the regular `git_commit_create()`,
 * updating the ref to point to the newly rewritten commit.  If you want
 * to amend a commit that is not currently the tip of the branch and then
 * rewrite the following commits to reach a ref, pass this as null and
 * update the rest of the commit chain and ref separately.
 *
 * Unlike `git_commit_create()`, the `author`, `committer`, `message`,
 * `message_encoding`, and `tree` parameters can be null in which case this
 * will use the values from the original `commit_to_amend`.
 *
 * All parameters have the same meanings as in `git_commit_create()`.
 *
 * @see git_commit_create
 */
@GIT_EXTERN
int git_commit_amend(libgit2.oid.git_oid* id, const (libgit2.types.git_commit)* commit_to_amend, const (char)* update_ref, const (libgit2.types.git_signature)* author, const (libgit2.types.git_signature)* committer, const (char)* message_encoding, const (char)* message, const (libgit2.types.git_tree)* tree);

/**
 * Create a commit and write it into a buffer
 *
 * Create a commit as with `git_commit_create()` but instead of
 * writing it to the objectdb, write the contents of the object into a
 * buffer.
 *
 * Params:
 *      out_ = the buffer into which to write the commit object content
 *      repo = Repository where the referenced tree and parents live
 *      author = Signature with author and author time of commit
 *      committer = Signature with committer and * commit time of commit
 *      message_encoding = The encoding for the message in the commit, represented with a standard encoding name. E.g. "UTF-8". If null, no encoding header is written and UTF-8 is assumed.
 *      message = Full message for this commit
 *      tree = An instance of a `git_tree` object that will be used as the tree for the commit. This tree object must also be owned by the given `repo`.
 *      parent_count = Number of parents for this commit
 *      parents = Array of `parent_count` pointers to `git_commit` objects that will be used as the parents for this commit. This array may be null if `parent_count` is 0 (root commit). All the given commits must be owned by the `repo`.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_commit_create_buffer(libgit2.buffer.git_buf* out_, libgit2.types.git_repository* repo, const (libgit2.types.git_signature)* author, const (libgit2.types.git_signature)* committer, const (char)* message_encoding, const (char)* message, const (libgit2.types.git_tree)* tree, size_t parent_count, const (libgit2.types.git_commit)** parents);

/**
 * Create a commit object from the given buffer and signature
 *
 * Given the unsigned commit object's contents, its signature and the
 * header field in which to store the signature, attach the signature
 * to the commit and write it into the given repository.
 *
 * Params:
 *      out_ = the resulting commit id
 *      repo = ?
 *      commit_content = the content of the unsigned commit object
 *      signature = the signature to add to the commit. Leave `NULL` to create a commit without adding a signature field.
 *      signature_field = which header field should contain this signature. Leave `NULL` for the default of "gpgsig"
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_commit_create_with_signature(libgit2.oid.git_oid* out_, libgit2.types.git_repository* repo, const (char)* commit_content, const (char)* signature, const (char)* signature_field);

/**
 * Create an in-memory copy of a commit. The copy must be explicitly
 * free'd or it will leak.
 *
 * Params:
 *      out_ = Pointer to store the copy of the commit
 *      source = Original commit to copy
 */
@GIT_EXTERN
int git_commit_dup(libgit2.types.git_commit** out_, libgit2.types.git_commit* source);

/**
 * Commit signing callback.
 *
 * The callback will be called with the commit content, giving a user an
 * opportunity to sign the commit content. The signature_field
 * buf may be left empty to specify the default field "gpgsig".
 *
 * Signatures can take the form of any string, and can be created on an arbitrary
 * header field. Signatures are most commonly used for verifying authorship of a
 * commit using GPG or a similar cryptographically secure signing algorithm.
 * See https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work for more
 * details.
 *
 * When the callback:
 * - returns git_error_code.GIT_PASSTHROUGH, no signature will be added to the commit.
 * - returns < 0, commit creation will be aborted.
 * - returns git_error_code.GIT_OK, the signature parameter is expected to be filled.
 */
alias git_commit_signing_cb = int function(libgit2.buffer.git_buf* signature, libgit2.buffer.git_buf* signature_field, const (char)* commit_content, void* payload);

/* @} */
