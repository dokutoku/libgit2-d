/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.odb;


private static import libgit2.indexer;
private static import libgit2.oid;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/odb.h
 * @brief Git object database routines
 * @defgroup git_odb Git object database routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Function type for callbacks from git_odb_foreach.
 */
alias git_odb_foreach_cb = int function(const (libgit2.oid.git_oid)* id, void* payload);

/**
 * Create a new object database with no backends.
 *
 * Before the ODB can be used for read/writing, a custom database
 * backend must be manually added using `git_odb_add_backend()`
 *
 * Params:
 *      out_ = location to store the database pointer, if opened. Set to null if the open failed.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_odb_new(libgit2.types.git_odb** out_);

/**
 * Create a new object database and automatically add
 * the two default backends:
 *
 *	- git_odb_backend_loose: read and write loose object files
 *		from disk, assuming `objects_dir` as the Objects folder
 *
 *	- git_odb_backend_pack: read objects from packfiles,
 *		assuming `objects_dir` as the Objects folder which
 *		contains a 'pack/' folder with the corresponding data
 *
 * Params:
 *      out_ = location to store the database pointer, if opened. Set to null if the open failed.
 *      objects_dir = path of the backends' "objects" directory.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_odb_open(libgit2.types.git_odb** out_, const (char)* objects_dir);

/**
 * Add an on-disk alternate to an existing Object DB.
 *
 * Note that the added path must point to an `objects`, not
 * to a full repository, to use it as an alternate store.
 *
 * Alternate backends are always checked for objects *after*
 * all the main backends have been exhausted.
 *
 * Writing is disabled on alternate backends.
 *
 * Params:
 *      odb = database to add the backend to
 *      path = path to the objects folder for the alternate
 *
 * Returns: 0 on success, error code otherwise
 */
@GIT_EXTERN
int git_odb_add_disk_alternate(libgit2.types.git_odb* odb, const (char)* path);

/**
 * Close an open object database.
 *
 * Params:
 *      db = database pointer to close. If null no action is taken.
 */
@GIT_EXTERN
void git_odb_free(libgit2.types.git_odb* db);

/**
 * Read an object from the database.
 *
 * This method queries all available ODB backends
 * trying to read the given OID.
 *
 * The returned object is reference counted and
 * internally cached, so it should be closed
 * by the user once it's no longer in use.
 *
 * Params:
 *      out_ = pointer where to store the read object
 *      db = database to search for the object in.
 *      id = identity of the object to read.
 *
 * Returns: 0 if the object was read, GIT_ENOTFOUND if the object is not in the database.
 */
@GIT_EXTERN
int git_odb_read(libgit2.types.git_odb_object** out_, libgit2.types.git_odb* db, const (libgit2.oid.git_oid)* id);

/**
 * Read an object from the database, given a prefix
 * of its identifier.
 *
 * This method queries all available ODB backends
 * trying to match the 'len' first hexadecimal
 * characters of the 'short_id'.
 * The remaining (GIT_OID_HEXSZ-len)*4 bits of
 * 'short_id' must be 0s.
 * 'len' must be at least GIT_OID_MINPREFIXLEN,
 * and the prefix must be long enough to identify
 * a unique object in all the backends; the
 * method will fail otherwise.
 *
 * The returned object is reference counted and
 * internally cached, so it should be closed
 * by the user once it's no longer in use.
 *
 * Params:
 *      out_ = pointer where to store the read object
 *      db = database to search for the object in.
 *      short_id = a prefix of the id of the object to read.
 *      len = the length of the prefix
 *
 * Returns: 0 if the object was read, GIT_ENOTFOUND if the object is not in the database. GIT_EAMBIGUOUS if the prefix is ambiguous(several objects match the prefix)
 */
@GIT_EXTERN
int git_odb_read_prefix(libgit2.types.git_odb_object** out_, libgit2.types.git_odb* db, const (libgit2.oid.git_oid)* short_id, size_t len);

/**
 * Read the header of an object from the database, without
 * reading its full contents.
 *
 * The header includes the length and the type of an object.
 *
 * Note that most backends do not support reading only the header
 * of an object, so the whole object will be read and then the
 * header will be returned.
 *
 * Params:
 *      len_out = pointer where to store the length
 *      type_out = pointer where to store the type
 *      db = database to search for the object in.
 *      id = identity of the object to read.
 *
 * Returns: 0 if the object was read, GIT_ENOTFOUND if the object is not in the database.
 */
@GIT_EXTERN
int git_odb_read_header(size_t* len_out, libgit2.types.git_object_t* type_out, libgit2.types.git_odb* db, const (libgit2.oid.git_oid)* id);

/**
 * Determine if the given object can be found in the object database.
 *
 * Params:
 *      db = database to be searched for the given object.
 *      id = the object to search for.
 *
 * Returns: 1 if the object was found, 0 otherwise
 */
@GIT_EXTERN
int git_odb_exists(libgit2.types.git_odb* db, const (libgit2.oid.git_oid)* id);

/**
 * Determine if an object can be found in the object database by an
 * abbreviated object ID.
 *
 * Params:
 *      out_ = The full OID of the found object if just one is found.
 *      db = The database to be searched for the given object.
 *      short_id = A prefix of the id of the object to read.
 *      len = The length of the prefix.
 *
 * Returns: 0 if found, git_error_code.GIT_ENOTFOUND if not found, git_error_code.GIT_EAMBIGUOUS if multiple matches were found, other value < 0 if there was a read error.
 */
@GIT_EXTERN
int git_odb_exists_prefix(libgit2.oid.git_oid* out_, libgit2.types.git_odb* db, const (libgit2.oid.git_oid)* short_id, size_t len);

/**
 * The information about object IDs to query in `git_odb_expand_ids`,
 * which will be populated upon return.
 */
struct git_odb_expand_id
{
	/**
	 * The object ID to expand
	 */
	libgit2.oid.git_oid id;

	/**
	 * The length of the object ID (in nibbles, or packets of 4 bits; the
	 * number of hex characters)
	 * */
	ushort length;

	/**
	 * The (optional) type of the object to search for; leave as `0` or set
	 * to `git_object_t.GIT_OBJECT_ANY` to query for any object matching the ID.
	 */
	libgit2.types.git_object_t type = cast(libgit2.types.git_object_t)(0);
}

/**
 * Determine if one or more objects can be found in the object database
 * by their abbreviated object ID and type.  The given array will be
 * updated in place:  for each abbreviated ID that is unique in the
 * database, and of the given type (if specified), the full object ID,
 * object ID length (`GIT_OID_HEXSZ`) and type will be written back to
 * the array.  For IDs that are not found (or are ambiguous), the
 * array entry will be zeroed.
 *
 * Note that since this function operates on multiple objects, the
 * underlying database will not be asked to be reloaded if an object is
 * not found (which is unlike other object database operations.)
 *
 * Params:
 *      db = The database to be searched for the given objects.
 *      ids = An array of short object IDs to search for
 *      count = The length of the `ids` array
 *
 * Returns: 0 on success or an error code on failure
 */
@GIT_EXTERN
int git_odb_expand_ids(libgit2.types.git_odb* db, .git_odb_expand_id* ids, size_t count);

/**
 * Refresh the object database to load newly added files.
 *
 * If the object databases have changed on disk while the library
 * is running, this function will force a reload of the underlying
 * indexes.
 *
 * Use this function when you're confident that an external
 * application has tampered with the ODB.
 *
 * NOTE that it is not necessary to call this function at all. The
 * library will automatically attempt to refresh the ODB
 * when a lookup fails, to see if the looked up object exists
 * on disk but hasn't been loaded yet.
 *
 * Params:
 *      db = database to refresh
 *
 * Returns: 0 on success, error code otherwise
 */
@GIT_EXTERN
int git_odb_refresh(libgit2.types.git_odb* db);

/**
 * List all objects available in the database
 *
 * The callback will be called for each object available in the
 * database. Note that the objects are likely to be returned in the index
 * order, which would make accessing the objects in that order inefficient.
 * Return a non-zero value from the callback to stop looping.
 *
 * Params:
 *      db = database to use
 *      cb = the callback to call for each object
 *      payload = data to pass to the callback
 *
 * Returns: 0 on success, non-zero callback return value, or error code
 */
@GIT_EXTERN
int git_odb_foreach(libgit2.types.git_odb* db, .git_odb_foreach_cb cb, void* payload);

/**
 * Write an object directly into the ODB
 *
 * This method writes a full object straight into the ODB.
 * For most cases, it is preferred to write objects through a write
 * stream, which is both faster and less memory intensive, specially
 * for big objects.
 *
 * This method is provided for compatibility with custom backends
 * which are not able to support streaming writes
 *
 * Params:
 *      out_ = pointer to store the OID result of the write
 *      odb = object database where to store the object
 *      data = buffer with the data to store
 *      len = size of the buffer
 *      type = type of the data to store
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_odb_write(libgit2.oid.git_oid* out_, libgit2.types.git_odb* odb, const (void)* data, size_t len, libgit2.types.git_object_t type);

/**
 * Open a stream to write an object into the ODB
 *
 * The type and final length of the object must be specified
 * when opening the stream.
 *
 * The returned stream will be of type `git_odb_stream_t.GIT_STREAM_WRONLY`, and it
 * won't be effective until `git_odb_stream_finalize_write` is called
 * and returns without an error
 *
 * The stream must always be freed when done with `git_odb_stream_free` or
 * will leak memory.
 *
 * @see git_odb_stream
 *
 * Params:
 *      out_ = pointer where to store the stream
 *      db = object database where the stream will write
 *      size = final size of the object that will be written
 *      type = type of the object that will be written
 *
 * Returns: 0 if the stream was created; error code otherwise
 */
@GIT_EXTERN
int git_odb_open_wstream(libgit2.types.git_odb_stream** out_, libgit2.types.git_odb* db, libgit2.types.git_object_size_t size, libgit2.types.git_object_t type);

/**
 * Write to an odb stream
 *
 * This method will fail if the total number of received bytes exceeds the
 * size declared with `git_odb_open_wstream()`
 *
 * Params:
 *      stream = the stream
 *      buffer = the data to write
 *      len = the buffer's length
 *
 * Returns: 0 if the write succeeded, error code otherwise
 */
@GIT_EXTERN
int git_odb_stream_write(libgit2.types.git_odb_stream* stream, const (char)* buffer, size_t len);

/**
 * Finish writing to an odb stream
 *
 * The object will take its final name and will be available to the
 * odb.
 *
 * This method will fail if the total number of received bytes
 * differs from the size declared with `git_odb_open_wstream()`
 *
 * Params:
 *      out_ = pointer to store the resulting object's id
 *      stream = the stream
 *
 * Returns: 0 on success, an error code otherwise
 */
@GIT_EXTERN
int git_odb_stream_finalize_write(libgit2.oid.git_oid* out_, libgit2.types.git_odb_stream* stream);

/**
 * Read from an odb stream
 *
 * Most backends don't implement streaming reads
 */
@GIT_EXTERN
int git_odb_stream_read(libgit2.types.git_odb_stream* stream, char* buffer, size_t len);

/**
 * Free an odb stream
 *
 * Params:
 *      stream = the stream to free
 */
@GIT_EXTERN
void git_odb_stream_free(libgit2.types.git_odb_stream* stream);

/**
 * Open a stream to read an object from the ODB
 *
 * Note that most backends do *not* support streaming reads
 * because they store their objects as compressed/delta'ed blobs.
 *
 * It's recommended to use `git_odb_read` instead, which is
 * assured to work on all backends.
 *
 * The returned stream will be of type `git_odb_stream_t.GIT_STREAM_RDONLY` and
 * will have the following methods:
 *
 *		- stream->read: read `n` bytes from the stream
 *		- stream->free: free the stream
 *
 * The stream must always be free'd or will leak memory.
 *
 * @see git_odb_stream
 *
 * Params:
 *      out_ = pointer where to store the stream
 *      len = pointer where to store the length of the object
 *      type = pointer where to store the type of the object
 *      db = object database where the stream will read from
 *      oid = oid of the object the stream will read from
 *
 * Returns: 0 if the stream was created, error code otherwise
 */
@GIT_EXTERN
int git_odb_open_rstream(libgit2.types.git_odb_stream** out_, size_t* len, libgit2.types.git_object_t* type, libgit2.types.git_odb* db, const (libgit2.oid.git_oid)* oid);

/**
 * Open a stream for writing a pack file to the ODB.
 *
 * If the ODB layer understands pack files, then the given
 * packfile will likely be streamed directly to disk (and a
 * corresponding index created).  If the ODB layer does not
 * understand pack files, the objects will be stored in whatever
 * format the ODB layer uses.
 *
 * @see git_odb_writepack
 *
 * Params:
 *      out_ = pointer to the writepack functions
 *      db = object database where the stream will read from
 *      progress_cb = function to call with progress information. Be aware that this is called inline with network and indexing operations, so performance may be affected.
 *      progress_payload = payload for the progress callback
 */
@GIT_EXTERN
int git_odb_write_pack(libgit2.types.git_odb_writepack** out_, libgit2.types.git_odb* db, libgit2.indexer.git_indexer_progress_cb progress_cb, void* progress_payload);

/**
 * Write a `multi-pack-index` file from all the `.pack` files in the ODB.
 *
 * If the ODB layer understands pack files, then this will create a file called
 * `multi-pack-index` next to the `.pack` and `.idx` files, which will contain
 * an index of all objects stored in `.pack` files. This will allow for
 * O(log n) lookup for n objects (regardless of how many packfiles there
 * exist).
 *
 * Params:
 *      db = object database where the `multi-pack-index` file will be written.
 */
@GIT_EXTERN
int git_odb_write_multi_pack_index(libgit2.types.git_odb* db);

/**
 * Determine the object-ID (sha1 hash) of a data buffer
 *
 * The resulting SHA-1 OID will be the identifier for the data
 * buffer as if the data buffer it were to written to the ODB.
 *
 * Params:
 *      out_ = the resulting object-ID.
 *      data = data to hash
 *      len = size of the data
 *      type = of the data to hash
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_odb_hash(libgit2.oid.git_oid* out_, const (void)* data, size_t len, libgit2.types.git_object_t type);

/**
 * Read a file from disk and fill a git_oid with the object id
 * that the file would have if it were written to the Object
 * Database as an object of the given type (w/o applying filters).
 * Similar functionality to git.git's `git hash-object` without
 * the `-w` flag, however, with the --no-filters flag.
 * If you need filters, see git_repository_hashfile.
 *
 * Params:
 *      out_ = oid structure the result is written into.
 *      path = file to read and determine object id for
 *      type = the type of the object that will be hashed
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_odb_hashfile(libgit2.oid.git_oid* out_, const (char)* path, libgit2.types.git_object_t type);

/**
 * Create a copy of an odb_object
 *
 * The returned copy must be manually freed with `git_odb_object_free`.
 * Note that because of an implementation detail, the returned copy will be
 * the same pointer as `source`: the object is internally refcounted, so the
 * copy still needs to be freed twice.
 *
 * Params:
 *      dest = pointer where to store the copy
 *      source = object to copy
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_odb_object_dup(libgit2.types.git_odb_object** dest, libgit2.types.git_odb_object* source);

/**
 * Close an ODB object
 *
 * This method must always be called once a `git_odb_object` is no
 * longer needed, otherwise memory will leak.
 *
 * Params:
 *      object = object to close
 */
@GIT_EXTERN
void git_odb_object_free(libgit2.types.git_odb_object* object);

/**
 * Return the OID of an ODB object
 *
 * This is the OID from which the object was read from
 *
 * Params:
 *      object = the object
 *
 * Returns: a pointer to the OID
 */
@GIT_EXTERN
const (libgit2.oid.git_oid)* git_odb_object_id(libgit2.types.git_odb_object* object);

/**
 * Return the data of an ODB object
 *
 * This is the uncompressed, raw data as read from the ODB,
 * without the leading header.
 *
 * This pointer is owned by the object and shall not be free'd.
 *
 * Params:
 *      object = the object
 *
 * Returns: a pointer to the data
 */
@GIT_EXTERN
const (void)* git_odb_object_data(libgit2.types.git_odb_object* object);

/**
 * Return the size of an ODB object
 *
 * This is the real size of the `data` buffer, not the
 * actual size of the object.
 *
 * Params:
 *      object = the object
 *
 * Returns: the size
 */
@GIT_EXTERN
size_t git_odb_object_size(libgit2.types.git_odb_object* object);

/**
 * Return the type of an ODB object
 *
 * Params:
 *      object = the object
 *
 * Returns: the type
 */
@GIT_EXTERN
libgit2.types.git_object_t git_odb_object_type(libgit2.types.git_odb_object* object);

/**
 * Add a custom backend to an existing Object DB
 *
 * The backends are checked in relative ordering, based on the
 * value of the `priority` parameter.
 *
 * Read <sys/odb_backend.h> for more information.
 *
 * Params:
 *      odb = database to add the backend to
 *      backend = pointer to a git_odb_backend instance
 *      priority = Value for ordering the backends queue
 *
 * Returns: 0 on success, error code otherwise
 */
@GIT_EXTERN
int git_odb_add_backend(libgit2.types.git_odb* odb, libgit2.types.git_odb_backend* backend, int priority);

/**
 * Add a custom backend to an existing Object DB; this
 * backend will work as an alternate.
 *
 * Alternate backends are always checked for objects *after*
 * all the main backends have been exhausted.
 *
 * The backends are checked in relative ordering, based on the
 * value of the `priority` parameter.
 *
 * Writing is disabled on alternate backends.
 *
 * Read <sys/odb_backend.h> for more information.
 *
 * Params:
 *      odb = database to add the backend to
 *      backend = pointer to a git_odb_backend instance
 *      priority = Value for ordering the backends queue
 *
 * Returns: 0 on success, error code otherwise
 */
@GIT_EXTERN
int git_odb_add_alternate(libgit2.types.git_odb* odb, libgit2.types.git_odb_backend* backend, int priority);

/**
 * Get the number of ODB backend objects
 *
 * Params:
 *      odb = object database
 *
 * Returns: number of backends in the ODB
 */
@GIT_EXTERN
size_t git_odb_num_backends(libgit2.types.git_odb* odb);

/**
 * Lookup an ODB backend object by index
 *
 * Params:
 *      out_ = output pointer to ODB backend at pos
 *      odb = object database
 *      pos = index into object database backend list
 *
 * Returns: 0 on success, git_error_code.GIT_ENOTFOUND if pos is invalid, other errors < 0
 */
@GIT_EXTERN
int git_odb_get_backend(libgit2.types.git_odb_backend** out_, libgit2.types.git_odb* odb, size_t pos);

/**
 * Set the git commit-graph for the ODB.
 *
 * After a successfull call, the ownership of the cgraph parameter will be
 * transferred to libgit2, and the caller should not free it.
 *
 * The commit-graph can also be unset by explicitly passing null as the cgraph
 * parameter.
 *
 * Params:
 *      odb = object database
 *      cgraph = the git commit-graph
 *
 * Returns: 0 on success; error code otherwise
 */
@GIT_EXTERN
int git_odb_set_commit_graph(libgit2.types.git_odb* odb, libgit2.types.git_commit_graph* cgraph);

/* @} */
