/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.message;


private static import libgit2_d.buffer;
private static import libgit2_d.common;

/**
 * @file git2/message.h
 * @brief Git message management routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:

/**
 * Clean up excess whitespace and make sure there is a trailing newline in the
 * message.
 *
 * Optionally, it can remove lines which start with the comment character.
 *
 * @param out_ The user-allocated git_buf which will be filled with the
 *     cleaned up message.
 *
 * @param message The message to be prettified.
 *
 * @param strip_comments Non-zero to remove comment lines, 0 to leave them in.
 *
 * @param comment_char Comment character. Lines starting with this character
 * are considered to be comments and removed if `strip_comments` is non-zero.
 *
 * @return 0 or an error code.
 */
//GIT_EXTERN
int git_message_prettify(libgit2_d.buffer.git_buf* out_, const (char)* message, int strip_comments, char comment_char);

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

	/* private */
	char* _trailer_block;
}

/**
 * Parse trailers out of a message, filling the array pointed to by +arr+.
 *
 * Trailers are key/value pairs in the last paragraph of a message, not
 * including any patches or conflicts that may be present.
 *
 * @param arr A pre-allocated git_message_trailer_array struct to be filled in
 *            with any trailers found during parsing.
 * @param message The message to be parsed
 * @return 0 on success, or non-zero on error.
 */
//GIT_EXTERN
int git_message_trailers(.git_message_trailer_array* arr, const (char)* message);

/**
 * Clean's up any allocated memory in the git_message_trailer_array filled by
 * a call to git_message_trailers.
 */
//GIT_EXTERN
void git_message_trailer_array_free(.git_message_trailer_array* arr);

/** @} */
