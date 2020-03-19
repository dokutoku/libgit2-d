/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.object;


private static import libgit2_d.buffer;
private static import libgit2_d.oid;
private static import libgit2_d.types;

/**
 * @file git2/object.h
 * @brief Git revision object management routines
 * @defgroup git_object Git revision object management routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

enum GIT_OBJECT_SIZE_MAX = ulong.max;

/**
 * Lookup a reference to one of the objects in a repository.
 *
 * The generated reference is owned by the repository and
 * should be closed with the `git_object_free` method
 * instead of free'd manually.
 *
 * The 'type' parameter must match the type of the object
 * in the odb; the method will fail otherwise.
 * The special value 'git_object_t.GIT_OBJECT_ANY' may be passed to let
 * the method guess the object's type.
 *
 * Params:
 *      object = pointer to the looked-up object
 *      repo = the repository to look up the object
 *      id = the unique identifier for the object
 *      type = the type of the object
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_object_lookup(libgit2_d.types.git_object** object, libgit2_d.types.git_repository* repo, const (libgit2_d.oid.git_oid)* id, libgit2_d.types.git_object_t type);

/**
 * Lookup a reference to one of the objects in a repository,
 * given a prefix of its identifier (short id).
 *
 * The object obtained will be so that its identifier
 * matches the first 'len' hexadecimal characters
 * (packets of 4 bits) of the given 'id'.
 * 'len' must be at least GIT_OID_MINPREFIXLEN, and
 * long enough to identify a unique object matching
 * the prefix; otherwise the method will fail.
 *
 * The generated reference is owned by the repository and
 * should be closed with the `git_object_free` method
 * instead of free'd manually.
 *
 * The 'type' parameter must match the type of the object
 * in the odb; the method will fail otherwise.
 * The special value 'git_object_t.GIT_OBJECT_ANY' may be passed to let
 * the method guess the object's type.
 *
 * Params:
 *      object_out = pointer where to store the looked-up object
 *      repo = the repository to look up the object
 *      id = a short identifier for the object
 *      len = the length of the short identifier
 *      type = the type of the object
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_object_lookup_prefix(libgit2_d.types.git_object** object_out, libgit2_d.types.git_repository* repo, const (libgit2_d.oid.git_oid)* id, size_t len, libgit2_d.types.git_object_t type);

/**
 * Lookup an object that represents a tree entry.
 *
 * Params:
 *      out_ = buffer that receives a pointer to the object (which must be freed by the caller)
 *      treeish = root object that can be peeled to a tree
 *      path = relative path from the root object to the desired object
 *      type = type of object desired
 *
 * Returns: 0 on success, or an error code
 */
//GIT_EXTERN
int git_object_lookup_bypath(libgit2_d.types.git_object** out_, const (libgit2_d.types.git_object)* treeish, const (char)* path, libgit2_d.types.git_object_t type);

/**
 * Get the id (SHA1) of a repository object
 *
 * Params:
 *      obj = the repository object
 *
 * Returns: the SHA1 id
 */
//GIT_EXTERN
const (libgit2_d.oid.git_oid)* git_object_id(const (libgit2_d.types.git_object)* obj);

/**
 * Get a short abbreviated OID string for the object
 *
 * This starts at the "core.abbrev" length (default 7 characters) and
 * iteratively extends to a longer string if that length is ambiguous.
 * The result will be unambiguous (at least until new objects are added to
 * the repository).
 *
 * Params:
 *      out_ = Buffer to write string into
 *      obj = The object to get an ID for
 *
 * Returns: 0 on success, <0 for error
 */
//GIT_EXTERN
int git_object_short_id(libgit2_d.buffer.git_buf* out_, const (libgit2_d.types.git_object)* obj);

/**
 * Get the object type of an object
 *
 * Params:
 *      obj = the repository object
 *
 * Returns: the object's type
 */
//GIT_EXTERN
libgit2_d.types.git_object_t git_object_type(const (libgit2_d.types.git_object)* obj);

/**
 * Get the repository that owns this object
 *
 * Freeing or calling `git_repository_close` on the
 * returned pointer will invalidate the actual object.
 *
 * Any other operation may be run on the repository without
 * affecting the object.
 *
 * Params:
 *      obj = the object
 *
 * Returns: the repository who owns this object
 */
//GIT_EXTERN
libgit2_d.types.git_repository* git_object_owner(const (libgit2_d.types.git_object)* obj);

/**
 * Close an open object
 *
 * This method instructs the library to close an existing
 * object; note that git_objects are owned and cached by the repository
 * so the object may or may not be freed after this library call,
 * depending on how aggressive is the caching mechanism used
 * by the repository.
 *
 * IMPORTANT:
 * It *is* necessary to call this method when you stop using
 * an object. Failure to do so will cause a memory leak.
 *
 * Params:
 *      object = the object to close
 */
//GIT_EXTERN
void git_object_free(libgit2_d.types.git_object* object);

/**
 * Convert an object type to its string representation.
 *
 * The result is a pointer to a string in static memory and
 * should not be free()'ed.
 *
 * Params:
 *      type = object type to convert.
 *
 * Returns: the corresponding string representation.
 */
//GIT_EXTERN
const (char)* git_object_type2string(libgit2_d.types.git_object_t type);

/**
 * Convert a string object type representation to it's libgit2_d.types.git_object_t.
 *
 * Params:
 *      str = the string to convert.
 *
 * Returns: the corresponding libgit2_d.types.git_object_t.
 */
//GIT_EXTERN
libgit2_d.types.git_object_t git_object_string2type(const (char)* str);

/**
 * Determine if the given libgit2_d.types.git_object_t is a valid loose object type.
 *
 * Params:
 *      type = object type to test.
 *
 * Returns: true if the type represents a valid loose object type, false otherwise.
 */
//GIT_EXTERN
int git_object_typeisloose(libgit2_d.types.git_object_t type);

/**
 * Recursively peel an object until an object of the specified type is met.
 *
 * If the query cannot be satisfied due to the object model,
 * git_error_code.GIT_EINVALIDSPEC will be returned (e.g. trying to peel a blob to a
 * tree).
 *
 * If you pass `git_object_t.GIT_OBJECT_ANY` as the target type, then the object will
 * be peeled until the type changes. A tag will be peeled until the
 * referenced object is no longer a tag, and a commit will be peeled
 * to a tree. Any other object type will return git_error_code.GIT_EINVALIDSPEC.
 *
 * If peeling a tag we discover an object which cannot be peeled to
 * the target type due to the object model, git_error_code.GIT_EPEEL will be
 * returned.
 *
 * You must free the returned object.
 *
 * Params:
 *      peeled = Pointer to the peeled git_object
 *      object = The object to be processed
 *      target_type = The type of the requested object (a GIT_OBJECT_ value)
 *
 * Returns: 0 on success, git_error_code.GIT_EINVALIDSPEC, git_error_code.GIT_EPEEL, or an error code
 */
//GIT_EXTERN
int git_object_peel(libgit2_d.types.git_object** peeled, const (libgit2_d.types.git_object)* object, libgit2_d.types.git_object_t target_type);

/**
 * Create an in-memory copy of a Git object. The copy must be
 * explicitly free'd or it will leak.
 *
 * Params:
 *      dest = Pointer to store the copy of the object
 *      source = Original object to copy
 */
//GIT_EXTERN
int git_object_dup(libgit2_d.types.git_object** dest, libgit2_d.types.git_object* source);

/** @} */
