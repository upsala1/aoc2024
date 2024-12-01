const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    defer _ = gpa.deinit();

    const stdout = std.io.getStdOut().writer();
    var file = std.fs.cwd().openFile("src/input.txt", .{}) catch {
        return;
    };
    defer file.close();
    var buffered_reader = std.io.bufferedReader(file.reader());
    const reader = buffered_reader.reader();
    var col_1 = std.ArrayList(i64).init(alloc);
    var col_2 = std.ArrayList(i64).init(alloc);
    defer col_1.deinit();
    defer col_2.deinit();
    var n: u32 = 1;
    while (try reader.readUntilDelimiterOrEofAlloc(alloc, '\n', 4096)) |line| {
        var tokenized_line = std.ArrayList([]const u8).init(alloc);
        defer tokenized_line.deinit();
        defer alloc.free(line);
        var split_line = std.mem.tokenizeSequence(u8, line, "   ");
        while (split_line.next()) |i| {
            try tokenized_line.append(i);
        }
        const c1 = try std.fmt.parseInt(i64, tokenized_line.items[0], 10);
        const c2 = try std.fmt.parseInt(i64, tokenized_line.items[1], 10);
        try col_1.append(c1);
        try col_2.append(c2);
        n += 1;
    }
    std.mem.sort(i64, col_1.items, {}, std.sort.asc(i64));
    std.mem.sort(i64, col_2.items, {}, std.sort.asc(i64));
    var sum_1: u64 = 0;
    sum_1 += 0;
    for (col_1.items, col_2.items) |a, b| {
        sum_1 += @abs(a - b);
    }
    //-----------------------------------------------------------------------------------------------------------------
    // Teil 2
    //-----------------------------------------------------------------------------------------------------------------
    var sum_2: u64 = 0;
    for (col_1.items) |a| {
        var count: u32 = 0;
        for (col_2.items) |b| {
            // can break because lists are sorted
            if (b > a) break;
            if (a == b) {
                count += 1;
            }
        }
        sum_2 += @abs(a * count);
    }
    try stdout.print("Antwort Teil 1: {d}\n", .{sum_1});
    try stdout.print("Antwort Teil 2: {d}\n", .{sum_2});
}
