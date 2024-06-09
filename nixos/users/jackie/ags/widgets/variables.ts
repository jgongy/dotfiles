import { execAsync } from "resource:///com/github/Aylur/ags/utils/exec.js";

export const date = Variable("", {
    poll: [1000, () => { return execAsync(["date", "+%H:%M:%S, %A, %d %b %Y"]) }],
});
