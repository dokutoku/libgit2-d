/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.message;


private static import libgit2.buffer;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/message.h
 * @brief Git message management routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Clean up excess whitespace and make sure there is a trailing newline in the
 * message.
 *
 * Optionally, it can remove lines which start with the comment character.
 *
 * Params:
 *      out_ = The user-allocated git_buf which will be filled with the cleaned up message.
 *      message = The message to be prettified.
 *      strip_comments = Non-zero to remove comment lines, 0 to leave them in.
 *      comment_char = Comment character. Lines starting with this character are considered to be comments and removed if `strip_comments` is non-zero.
 *
 * Returns: 0 or an error code.
 */
@GIT_EXTERN
int git_message_prettify(libgit2.buffer.git_buf* out_, const (char)* message, int strip_comments, char comment_char);

/**
 * Represents a single git message trailer.
 */
struct git_message_trailer
{
	const (char)* key;
	const (char)* value;
}

/**
 * Represents an array of git message trailers.
 *
 * Struct members under the private comment are private, subject to change
 * and should not be used by callers.
 */
struct git_message_trailer_array
{
	.git_message_trailer* trailers;
	size_t count;

package:
	char* _trailer_block;
}

/**
 * Parse trailers out of a message, filling the array pointed to by +arr+.
 *
 * Trailers are key/value pairs in the last paragraph of a message, not
 * including any patches or conflicts that may be present.
 *
 * Params:
 *      arr = A pre-allocated git_message_trailer_array struct to be filled in with any trailers found during parsing.
 *      message = The message to be parsed
 *
 * Returns: 0 on success, or non-zero on error.
 */
@GIT_EXTERN
int git_message_trailers(.git_message_trailer_array* arr, const (char)* message);

/**
 * Clean's up any allocated memory in the git_message_trailer_array filled by
 * a call to git_message_trailers.
 *
 * Params:
 *      arr = The trailer to free.
 */
@GIT_EXTERN
void git_message_trailer_array_free(.git_message_trailer_array* arr);

/* @} */
