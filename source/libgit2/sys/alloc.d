/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.sys.alloc;


extern (C):
nothrow @nogc:
package(libgit2):

/**
 * An instance for a custom memory allocator
 *
 * Setting the pointers of this structure allows the developer to implement
 * custom memory allocators. The global memory allocator can be set by using
 * "git_libgit2_opt_t.GIT_OPT_SET_ALLOCATOR" with the `git_libgit2_opts` function. Keep in mind
 * that all fields need to be set to a proper function.
 */
struct git_allocator
{
	/**
	 * Allocate `n` bytes of memory
	 */
	void* function(size_t n, const (char)* file, int line) gmalloc;

	/**
	 * Allocate memory for an array of `nelem` elements, where each element
	 * has a size of `elsize`. Returned memory shall be initialized to
	 * all-zeroes
	 */
	void* function(size_t nelem, size_t elsize, const (char)* file, int line) gcalloc;

	/**
	 * Allocate memory for the string `str` and duplicate its contents.
	 */
	char* function(const (char)* str, const (char)* file, int line) gstrdup;

	/**
	 * Equivalent to the `gstrdup` function, but only duplicating at most
	 * `n + 1` bytes
	 */
	char* function(const (char)* str, size_t n, const (char)* file, int line) gstrndup;

	/**
	 * Equivalent to `gstrndup`, but will always duplicate exactly `n` bytes
	 * of `str`. Thus, out of bounds reads at `str` may happen.
	 */
	char* function(const (char)* str, size_t n, const (char)* file, int line) gsubstrdup;

	/**
	 * This function shall deallocate the old object `ptr_` and return a
	 * pointer to a new object that has the size specified by `size`. In
	 * case `ptr_` is `null`, a new array shall be allocated.
	 */
	void* function(void* ptr_, size_t size, const (char)* file, int line) grealloc;

	/**
	 * This function shall be equivalent to `grealloc`, but allocating
	 * `neleme * elsize` bytes.
	 */
	void* function(void* ptr_, size_t nelem, size_t elsize, const (char)* file, int line) greallocarray;

	/**
	 * This function shall allocate a new array of `nelem` elements, where
	 * each element has a size of `elsize` bytes.
	 */
	void* function(size_t nelem, size_t elsize, const (char)* file, int line) gmallocarray;

	/**
	 * This function shall free the memory pointed to by `ptr_`. In case
	 * `ptr_` is `null`, this shall be a no-op.
	 */
	void function(void* ptr_) gfree;
}

/**
 * Initialize the allocator structure to use the `stdalloc` pointer.
 *
 * Set up the structure so that all of its members are using the standard
 * "stdalloc" allocator functions. The structure can then be used with
 * `git_allocator_setup`.
 *
 * Params:
 *      allocator = The allocator that is to be initialized.
 *
 * Returns: An error code or 0.
 */
int git_stdalloc_init_allocator(.git_allocator* allocator);

/**
 * Initialize the allocator structure to use the `crtdbg` pointer.
 *
 * Set up the structure so that all of its members are using the "crtdbg"
 * allocator functions. Note that this allocator is only available on Windows
 * platforms and only if libgit2 is being compiled with "-DMSVC_CRTDBG".
 *
 * Params:
 *      allocator = The allocator that is to be initialized.
 *
 * Returns: An error code or 0.
 */
int git_win32_crtdbg_init_allocator(.git_allocator* allocator);
