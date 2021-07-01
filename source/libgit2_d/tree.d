/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.tree;


private static import libgit2_d.buffer;
private static import libgit2_d.oid;
private static import libgit2_d.types;

/**
 * @file git2/tree.h
 * @brief Git tree parsing, loading routines
 * @defgroup git_tree Git tree parsing, loading routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Lookup a tree object from the repository.
 *
 * Params:
 *      out_ = Pointer to the looked up tree
 *      repo = The repo to use when locating the tree.
 *      id = Identity of the tree to locate.
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_tree_lookup(libgit2_d.types.git_tree** out_, libgit2_d.types.git_repository* repo, const (libgit2_d.oid.git_oid)* id);

/**
 * Lookup a tree object from the repository,
 * given a prefix of its identifier (short id).
 *
 * @see git_object_lookup_prefix
 *
 * Params:
 *      out_ = pointer to the looked up tree
 *      repo = the repo to use when locating the tree.
 *      id = identity of the tree to locate.
 *      len = the length of the short identifier
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_tree_lookup_prefix(libgit2_d.types.git_tree** out_, libgit2_d.types.git_repository* repo, const (libgit2_d.oid.git_oid)* id, size_t len);

/**
 * Close an open tree
 *
 * You can no longer use the git_tree pointer after this call.
 *
 * IMPORTANT: You MUST call this method when you stop using a tree to
 * release memory. Failure to do so will cause a memory leak.
 *
 * Params:
 *      tree = The tree to close
 */
//GIT_EXTERN
void git_tree_free(libgit2_d.types.git_tree* tree);

/**
 * Get the id of a tree.
 *
 * Params:
 *      tree = a previously loaded tree.
 *
 * Returns: object identity for the tree.
 */
//GIT_EXTERN
const (libgit2_d.oid.git_oid)* git_tree_id(const (libgit2_d.types.git_tree)* tree);

/**
 * Get the repository that contains the tree.
 *
 * Params:
 *      tree = A previously loaded tree.
 *
 * Returns: Repository that contains this tree.
 */
//GIT_EXTERN
libgit2_d.types.git_repository* git_tree_owner(const (libgit2_d.types.git_tree)* tree);

/**
 * Get the number of entries listed in a tree
 *
 * Params:
 *      tree = a previously loaded tree.
 *
 * Returns: the number of entries in the tree
 */
//GIT_EXTERN
size_t git_tree_entrycount(const (libgit2_d.types.git_tree)* tree);

/**
 * Lookup a tree entry by its filename
 *
 * This returns a git_tree_entry that is owned by the git_tree.  You don't
 * have to free it, but you must not use it after the git_tree is released.
 *
 * Params:
 *      tree = a previously loaded tree.
 *      filename = the filename of the desired entry
 *
 * Returns: the tree entry; null if not found
 */
//GIT_EXTERN
const (libgit2_d.types.git_tree_entry)* git_tree_entry_byname(const (libgit2_d.types.git_tree)* tree, const (char)* filename);

/**
 * Lookup a tree entry by its position in the tree
 *
 * This returns a git_tree_entry that is owned by the git_tree.  You don't
 * have to free it, but you must not use it after the git_tree is released.
 *
 * Params:
 *      tree = a previously loaded tree.
 *      idx = the position in the entry list
 *
 * Returns: the tree entry; null if not found
 */
//GIT_EXTERN
const (libgit2_d.types.git_tree_entry)* git_tree_entry_byindex(const (libgit2_d.types.git_tree)* tree, size_t idx);

/**
 * Lookup a tree entry by SHA value.
 *
 * This returns a git_tree_entry that is owned by the git_tree.  You don't
 * have to free it, but you must not use it after the git_tree is released.
 *
 * Warning: this must examine every entry in the tree, so it is not fast.
 *
 * Params:
 *      tree = a previously loaded tree.
 *      id = the sha being looked for
 *
 * Returns: the tree entry; null if not found
 */
//GIT_EXTERN
const (libgit2_d.types.git_tree_entry)* git_tree_entry_byid(const (libgit2_d.types.git_tree)* tree, const (libgit2_d.oid.git_oid)* id);

/**
 * Retrieve a tree entry contained in a tree or in any of its subtrees,
 * given its relative path.
 *
 * Unlike the other lookup functions, the returned tree entry is owned by
 * the user and must be freed explicitly with `git_tree_entry_free()`.
 *
 * Params:
 *      out_ = Pointer where to store the tree entry
 *      root = Previously loaded tree which is the root of the relative path
 *      path = Path to the contained entry
 *
 * Returns: 0 on success; git_error_code.GIT_ENOTFOUND if the path does not exist
 */
//GIT_EXTERN
int git_tree_entry_bypath(libgit2_d.types.git_tree_entry** out_, const (libgit2_d.types.git_tree)* root, const (char)* path);

/**
 * Duplicate a tree entry
 *
 * Create a copy of a tree entry. The returned copy is owned by the user,
 * and must be freed explicitly with `git_tree_entry_free()`.
 *
 * Params:
 *      dest = pointer where to store the copy
 *      source = tree entry to duplicate
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_tree_entry_dup(libgit2_d.types.git_tree_entry** dest, const (libgit2_d.types.git_tree_entry)* source);

/**
 * Free a user-owned tree entry
 *
 * IMPORTANT: This function is only needed for tree entries owned by the
 * user, such as the ones returned by `git_tree_entry_dup()` or
 * `git_tree_entry_bypath()`.
 *
 * Params:
 *      entry = The entry to free
 */
//GIT_EXTERN
void git_tree_entry_free(libgit2_d.types.git_tree_entry* entry);

/**
 * Get the filename of a tree entry
 *
 * Params:
 *      entry = a tree entry
 *
 * Returns: the name of the file
 */
//GIT_EXTERN
const (char)* git_tree_entry_name(const (libgit2_d.types.git_tree_entry)* entry);

/**
 * Get the id of the object pointed by the entry
 *
 * Params:
 *      entry = a tree entry
 *
 * Returns: the oid of the object
 */
//GIT_EXTERN
const (libgit2_d.oid.git_oid)* git_tree_entry_id(const (libgit2_d.types.git_tree_entry)* entry);

/**
 * Get the type of the object pointed by the entry
 *
 * Params:
 *      entry = a tree entry
 *
 * Returns: the type of the pointed object
 */
//GIT_EXTERN
libgit2_d.types.git_object_t git_tree_entry_type(const (libgit2_d.types.git_tree_entry)* entry);

/**
 * Get the UNIX file attributes of a tree entry
 *
 * Params:
 *      entry = a tree entry
 *
 * Returns: filemode as an integer
 */
//GIT_EXTERN
libgit2_d.types.git_filemode_t git_tree_entry_filemode(const (libgit2_d.types.git_tree_entry)* entry);

/**
 * Get the raw UNIX file attributes of a tree entry
 *
 * This function does not perform any normalization and is only useful
 * if you need to be able to recreate the original tree object.
 *
 * Params:
 *      entry = a tree entry
 *
 * Returns: filemode as an integer
 */

//GIT_EXTERN
libgit2_d.types.git_filemode_t git_tree_entry_filemode_raw(const (libgit2_d.types.git_tree_entry)* entry);

/**
 * Compare two tree entries
 *
 * Params:
 *      e1 = first tree entry
 *      e2 = second tree entry
 *
 * Returns: <0 if e1 is before e2, 0 if e1 == e2, >0 if e1 is after e2
 */
//GIT_EXTERN
int git_tree_entry_cmp(const (libgit2_d.types.git_tree_entry)* e1, const (libgit2_d.types.git_tree_entry)* e2);

/**
 * Convert a tree entry to the git_object it points to.
 *
 * You must call `git_object_free()` on the object when you are done with it.
 *
 * Params:
 *      object_out = pointer to the converted object
 *      repo = repository where to lookup the pointed object
 *      entry = a tree entry
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_tree_entry_to_object(libgit2_d.types.git_object** object_out, libgit2_d.types.git_repository* repo, const (libgit2_d.types.git_tree_entry)* entry);

/**
 * Create a new tree builder.
 *
 * The tree builder can be used to create or modify trees in memory and
 * write them as tree objects to the database.
 *
 * If the `source` parameter is not null, the tree builder will be
 * initialized with the entries of the given tree.
 *
 * If the `source` parameter is null, the tree builder will start with no
 * entries and will have to be filled manually.
 *
 * Params:
 *      out_ = Pointer where to store the tree builder
 *      repo = Repository in which to store the object
 *      source = Source tree to initialize the builder (optional)
 *
 * Returns: 0 on success; error code otherwise
 */
//GIT_EXTERN
int git_treebuilder_new(libgit2_d.types.git_treebuilder** out_, libgit2_d.types.git_repository* repo, const (libgit2_d.types.git_tree)* source);

/**
 * Clear all the entires in the builder
 *
 * Params:
 *      bld = Builder to clear
 *
 * Returns: 0 on success; error code otherwise
 */
//GIT_EXTERN
int git_treebuilder_clear(libgit2_d.types.git_treebuilder* bld);

/**
 * Get the number of entries listed in a treebuilder
 *
 * Params:
 *      bld = a previously loaded treebuilder.
 *
 * Returns: the number of entries in the treebuilder
 */
//GIT_EXTERN
size_t git_treebuilder_entrycount(libgit2_d.types.git_treebuilder* bld);

/**
 * Free a tree builder
 *
 * This will clear all the entries and free to builder.
 * Failing to free the builder after you're done using it
 * will result in a memory leak
 *
 * Params:
 *      bld = Builder to free
 */
//GIT_EXTERN
void git_treebuilder_free(libgit2_d.types.git_treebuilder* bld);

/**
 * Get an entry from the builder from its filename
 *
 * The returned entry is owned by the builder and should
 * not be freed manually.
 *
 * Params:
 *      bld = Tree builder
 *      filename = Name of the entry
 *
 * Returns: pointer to the entry; null if not found
 */
//GIT_EXTERN
const (libgit2_d.types.git_tree_entry)* git_treebuilder_get(libgit2_d.types.git_treebuilder* bld, const (char)* filename);

/**
 * Add or update an entry to the builder
 *
 * Insert a new entry for `filename` in the builder with the
 * given attributes.
 *
 * If an entry named `filename` already exists, its attributes
 * will be updated with the given ones.
 *
 * The optional pointer `out` can be used to retrieve a pointer to the
 * newly created/updated entry.  Pass null if you do not need it. The
 * pointer may not be valid past the next operation in this
 * builder. Duplicate the entry if you want to keep it.
 *
 * By default the entry that you are inserting will be checked for
 * validity; that it exists in the object database and is of the
 * correct type.  If you do not want this behavior, set the
 * `git_libgit2_opt_t.GIT_OPT_ENABLE_STRICT_OBJECT_CREATION` library option to false.
 *
 * Params:
 *      out_ = Pointer to store the entry (optional)
 *      bld = Tree builder
 *      filename = Filename of the entry
 *      id = SHA1 oid of the entry
 *      filemode = Folder attributes of the entry. This parameter must be valued with one of the following entries: 0040000, 0100644, 0100755, 0120000 or 0160000.
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_treebuilder_insert(const (libgit2_d.types.git_tree_entry)** out_, libgit2_d.types.git_treebuilder* bld, const (char)* filename, const (libgit2_d.oid.git_oid)* id, libgit2_d.types.git_filemode_t filemode);

/**
 * Remove an entry from the builder by its filename
 *
 * Params:
 *      bld = Tree builder
 *      filename = Filename of the entry to remove
 */
//GIT_EXTERN
int git_treebuilder_remove(libgit2_d.types.git_treebuilder* bld, const (char)* filename);

/**
 * Callback for git_treebuilder_filter
 *
 * The return value is treated as a boolean, with zero indicating that the
 * entry should be left alone and any non-zero value meaning that the
 * entry should be removed from the treebuilder list (i.e. filtered out).
 */
alias git_treebuilder_filter_cb = int function(const (libgit2_d.types.git_tree_entry)* entry, void* payload);

/**
 * Selectively remove entries in the tree
 *
 * The `filter` callback will be called for each entry in the tree with a
 * pointer to the entry and the provided `payload`; if the callback returns
 * non-zero, the entry will be filtered (removed from the builder).
 *
 * Params:
 *      bld = Tree builder
 *      filter = Callback to filter entries
 *      payload = Extra data to pass to filter callback
 *
 * Returns: 0 on success, non-zero callback return value, or error code
 */
//GIT_EXTERN
int git_treebuilder_filter(libgit2_d.types.git_treebuilder* bld, .git_treebuilder_filter_cb filter, void* payload);

/**
 * Write the contents of the tree builder as a tree object
 *
 * The tree builder will be written to the given `repo`, and its
 * identifying SHA1 hash will be stored in the `id` pointer.
 *
 * Params:
 *      id = Pointer to store the OID of the newly written tree
 *      bld = Tree builder to write
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_treebuilder_write(libgit2_d.oid.git_oid* id, libgit2_d.types.git_treebuilder* bld);

/**
 * Write the contents of the tree builder as a tree object
 * using a shared git_buf.
 *
 * @see git_treebuilder_write
 *
 * Params:
 *      oid = Pointer to store the OID of the newly written tree
 *      bld = Tree builder to write
 *      tree = Shared buffer for writing the tree. Will be grown as necessary.
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_treebuilder_write_with_buffer(libgit2_d.oid.git_oid* oid, libgit2_d.types.git_treebuilder* bld, libgit2_d.buffer.git_buf* tree);

/**
 * Callback for the tree traversal method
 */
alias git_treewalk_cb = int function(const (char)* root, const (libgit2_d.types.git_tree_entry)* entry, void* payload);

/**
 * Tree traversal modes
 */
enum git_treewalk_mode
{
	/**
	 * Pre-order
	 */
	GIT_TREEWALK_PRE = 0,

	/**
	 * Post-order
	 */
	GIT_TREEWALK_POST = 1,
}

//Declaration name in C language
enum
{
	GIT_TREEWALK_PRE = .git_treewalk_mode.GIT_TREEWALK_PRE,
	GIT_TREEWALK_POST = .git_treewalk_mode.GIT_TREEWALK_POST,
}

/**
 * Traverse the entries in a tree and its subtrees in post or pre order.
 *
 * The entries will be traversed in the specified order, children subtrees
 * will be automatically loaded as required, and the `callback` will be
 * called once per entry with the current (relative) root for the entry and
 * the entry data itself.
 *
 * If the callback returns a positive value, the passed entry will be
 * skipped on the traversal (in pre mode). A negative value stops the walk.
 *
 * Params:
 *      tree = The tree to walk
 *      mode = Traversal mode (pre or post-order)
 *      callback = Function to call on each tree entry
 *      payload = Opaque pointer to be passed on each callback
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_tree_walk(const (libgit2_d.types.git_tree)* tree, .git_treewalk_mode mode, .git_treewalk_cb callback, void* payload);

/**
 * Create an in-memory copy of a tree. The copy must be explicitly
 * free'd or it will leak.
 *
 * Params:
 *      out_ = Pointer to store the copy of the tree
 *      source = Original tree to copy
 */
//GIT_EXTERN
int git_tree_dup(libgit2_d.types.git_tree** out_, libgit2_d.types.git_tree* source);

/**
 * The kind of update to perform
 */
enum git_tree_update_t
{
	/**
	 * Update or insert an entry at the specified path
	 */
	GIT_TREE_UPDATE_UPSERT,

	/**
	 * Remove an entry from the specified path
	 */
	GIT_TREE_UPDATE_REMOVE,
}

//Declaration name in C language
enum
{
	GIT_TREE_UPDATE_UPSERT = .git_tree_update_t.GIT_TREE_UPDATE_UPSERT,
	GIT_TREE_UPDATE_REMOVE = .git_tree_update_t.GIT_TREE_UPDATE_REMOVE,
}

/**
 * An action to perform during the update of a tree
 */
struct git_tree_update
{
	/**
	 * Update action. If it's an removal, only the path is looked at
	 */
	.git_tree_update_t action;

	/**
	 * The entry's id
	 */
	libgit2_d.oid.git_oid id;

	/**
	 * The filemode/kind of object
	 */
	libgit2_d.types.git_filemode_t filemode;

	/**
	 * The full path from the root tree
	 */
	const (char)* path;
}

/**
 * Create a tree based on another one with the specified modifications
 *
 * Given the `baseline` perform the changes described in the list of
 * `updates` and create a new tree.
 *
 * This function is optimized for common file/directory addition, removal and
 * replacement in trees. It is much more efficient than reading the tree into a
 * `git_index` and modifying that, but in exchange it is not as flexible.
 *
 * Deleting and adding the same entry is undefined behaviour, changing
 * a tree to a blob or viceversa is not supported.
 *
 * Params:
 *      out_ = id of the new tree
 *      repo = the repository in which to create the tree, must be the same as for `baseline`
 *      baseline = the tree to base these changes on
 *      nupdates = the number of elements in the update list
 *      updates = the list of updates to perform
 */
//GIT_EXTERN
int git_tree_create_updated(libgit2_d.oid.git_oid* out_, libgit2_d.types.git_repository* repo, libgit2_d.types.git_tree* baseline, size_t nupdates, const (.git_tree_update)* updates);

/** @} */
