//
//  Originally from:
//  externalCStuff.h
//  jailbreakd - externalCStuff
//
//  Created by Linus Henze.
//  Copyright © 2021 Linus Henze. All rights reserved.
//

#ifndef PersonaSpawn_h
#define PersonaSpawn_h

#include <spawn.h>

int     posix_spawnattr_set_persona_np(const posix_spawnattr_t * __restrict, uid_t, uint32_t);
int     posix_spawnattr_set_persona_uid_np(const posix_spawnattr_t * __restrict, uid_t);
int     posix_spawnattr_set_persona_gid_np(const posix_spawnattr_t * __restrict, gid_t);

#endif /* PersonaSpawn_h */
