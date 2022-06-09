/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.notes;


private static import libgit2_d.buffer;
private static import libgit2_d.oid;
private static import libgit2_d.types;

/*
 * @file git2/notes.h
 * @brief Git notes management routines
 * @defgroup git_note Git notes management routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Callback for git_note_foreach.
 *
 * Receives:
 * - blob_id: Oid of the blob containing the message
 * - annotated_object_id: Oid of the git object being annotated
 * - payload: Payload data passed to `git_note_foreach`
 */
alias git_note_foreach_cb = int function(const (libgit2_d.oid.git_oid)* blob_id, const (libgit2_d.oid.git_oid)* annotated_object_id, void* payload);

/**
 * note iterator
 */
struct git_iterator;
alias git_note_iterator = git_iterator;

/**
 * Creates a new iterator for notes
 *
 * The iterator must be freed manually by the user.
 *
 * Params:
 *      out_ = pointer to the iterator
 *      repo = repository where to look up the note
 *      notes_ref = canonical name of the reference to use (optional); defaults to "refs/notes/commits"
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_note_iterator_new(.git_note_iterator** out_, libgit2_d.types.git_repository* repo, const (char)* notes_ref);

/**
 * Creates a new iterator for notes from a commit
 *
 * The iterator must be freed manually by the user.
 *
 * Params:
 *      out_ = pointer to the iterator
 *      notes_commit = a pointer to the notes commit object
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_note_commit_iterator_new(.git_note_iterator** out_, libgit2_d.types.git_commit* notes_commit);

/**
 * Frees an git_note_iterator
 *
 * Params:
 *      it = pointer to the iterator
 */
//GIT_EXTERN
void git_note_iterator_free(.git_note_iterator* it);

/**
 * Return the current item (note_id and annotated_id) and advance the iterator
 * internally to the next value
 *
 * Params:
 *      note_id = id of blob containing the message
 *      annotated_id = id of the git object being annotated
 *      it = pointer to the iterator
 *
 * Returns: 0 (no error), git_error_code.GIT_ITEROVER (iteration is done) or an error code (negative value)
 */
//GIT_EXTERN
int git_note_next(libgit2_d.oid.git_oid* note_id, libgit2_d.oid.git_oid* annotated_id, .git_note_iterator* it);

/**
 * Read the note for an object
 *
 * The note must be freed manually by the user.
 *
 * Params:
 *      out_ = pointer to the read note; null in case of error
 *      repo = repository where to look up the note
 *      notes_ref = canonical name of the reference to use (optional); defaults to "refs/notes/commits"
 *      oid = OID of the git object to read the note from
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_note_read(libgit2_d.types.git_note** out_, libgit2_d.types.git_repository* repo, const (char)* notes_ref, const (libgit2_d.oid.git_oid)* oid);

/**
 * Read the note for an object from a note commit
 *
 * The note must be freed manually by the user.
 *
 * Params:
 *      out_ = pointer to the read note; null in case of error
 *      repo = repository where to look up the note
 *      notes_commit = a pointer to the notes commit object
 *      oid = OID of the git object to read the note from
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_note_commit_read(libgit2_d.types.git_note** out_, libgit2_d.types.git_repository* repo, libgit2_d.types.git_commit* notes_commit, const (libgit2_d.oid.git_oid)* oid);

/**
 * Get the note author
 *
 * Params:
 *      note = the note
 *
 * Returns: the author
 */
//GIT_EXTERN
const (libgit2_d.types.git_signature)* git_note_author(const (libgit2_d.types.git_note)* note);

/**
 * Get the note committer
 *
 * Params:
 *      note = the note
 *
 * Returns: the committer
 */
//GIT_EXTERN
const (libgit2_d.types.git_signature)* git_note_committer(const (libgit2_d.types.git_note)* note);

/**
 * Get the note message
 *
 * Params:
 *      note = the note
 *
 * Returns: the note message
 */
//GIT_EXTERN
const (char)* git_note_message(const (libgit2_d.types.git_note)* note);

/**
 * Get the note object's id
 *
 * Params:
 *      note = the note
 *
 * Returns: the note object's id
 */
//GIT_EXTERN
const (libgit2_d.oid.git_oid)* git_note_id(const (libgit2_d.types.git_note)* note);

/**
 * Add a note for an object
 *
 * Params:
 *      out_ = pointer to store the OID (optional); null in case of error
 *      repo = repository where to store the note
 *      notes_ref = canonical name of the reference to use (optional); defaults to "refs/notes/commits"
 *      author = signature of the notes commit author
 *      committer = signature of the notes commit committer
 *      oid = OID of the git object to decorate
 *      note = Content of the note to add for object oid
 *      force = Overwrite existing note
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_note_create(libgit2_d.oid.git_oid* out_, libgit2_d.types.git_repository* repo, const (char)* notes_ref, const (libgit2_d.types.git_signature)* author, const (libgit2_d.types.git_signature)* committer, const (libgit2_d.oid.git_oid)* oid, const (char)* note, int force);

/**
 * Add a note for an object from a commit
 *
 * This function will create a notes commit for a given object,
 * the commit is a dangling commit, no reference is created.
 *
 * Params:
 *      notes_commit_out = pointer to store the commit (optional); null in case of error
 *      notes_blob_out = a point to the id of a note blob (optional)
 *      repo = repository where the note will live
 *      parent = Pointer to parent note or null if this shall start a new notes tree
 *      author = signature of the notes commit author
 *      committer = signature of the notes commit committer
 *      oid = OID of the git object to decorate
 *      note = Content of the note to add for object oid
 *      allow_note_overwrite = Overwrite existing note
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_note_commit_create(libgit2_d.oid.git_oid* notes_commit_out, libgit2_d.oid.git_oid* notes_blob_out, libgit2_d.types.git_repository* repo, libgit2_d.types.git_commit* parent, const (libgit2_d.types.git_signature)* author, const (libgit2_d.types.git_signature)* committer, const (libgit2_d.oid.git_oid)* oid, const (char)* note, int allow_note_overwrite);

/**
 * Remove the note for an object
 *
 * Params:
 *      repo = repository where the note lives
 *      notes_ref = canonical name of the reference to use (optional); defaults to "refs/notes/commits"
 *      author = signature of the notes commit author
 *      committer = signature of the notes commit committer
 *      oid = OID of the git object to remove the note from
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_note_remove(libgit2_d.types.git_repository* repo, const (char)* notes_ref, const (libgit2_d.types.git_signature)* author, const (libgit2_d.types.git_signature)* committer, const (libgit2_d.oid.git_oid)* oid);

/**
 * Remove the note for an object
 *
 * Params:
 *      notes_commit_out = pointer to store the new notes commit (optional); null in case of error. When removing a note a new tree containing all notes sans the note to be removed is created and a new commit pointing to that tree is also created. In the case where the resulting tree is an empty tree a new commit pointing to this empty tree will be returned.
 *      repo = repository where the note lives
 *      notes_commit = a pointer to the notes commit object
 *      author = signature of the notes commit author
 *      committer = signature of the notes commit committer
 *      oid = OID of the git object to remove the note from
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_note_commit_remove(libgit2_d.oid.git_oid* notes_commit_out, libgit2_d.types.git_repository* repo, libgit2_d.types.git_commit* notes_commit, const (libgit2_d.types.git_signature)* author, const (libgit2_d.types.git_signature)* committer, const (libgit2_d.oid.git_oid)* oid);

/**
 * Free a git_note object
 *
 * Params:
 *      note = git_note object
 */
//GIT_EXTERN
void git_note_free(libgit2_d.types.git_note* note);

/**
 * Get the default notes reference for a repository
 *
 * Params:
 *      out_ = buffer in which to store the name of the default notes reference
 *      repo = The Git repository
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_note_default_ref(libgit2_d.buffer.git_buf* out_, libgit2_d.types.git_repository* repo);

/**
 * Loop over all the notes within a specified namespace
 * and issue a callback for each one.
 *
 * Params:
 *      repo = Repository where to find the notes.
 *      notes_ref = Reference to read from (optional); defaults to "refs/notes/commits".
 *      note_cb = Callback to invoke per found annotation.  Return non-zero to stop looping.
 *      payload = Extra parameter to callback function.
 *
 * Returns: 0 on success, non-zero callback return value, or error code
 */
//GIT_EXTERN
int git_note_foreach(libgit2_d.types.git_repository* repo, const (char)* notes_ref, .git_note_foreach_cb note_cb, void* payload);

/* @} */
