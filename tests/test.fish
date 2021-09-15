#!/usr/bin/env fish
source ./functions/*.fish
@test "dangerload-include function should exist" (dangerload-include) $status -eq 0