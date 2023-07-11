# tree_view_flutter

Thư viện `tree_view_flutter` giúp xây dựng một cấu trúc dữ liệu kiểu cây và trực quan hoá chúng dưới dạng cây kế thừa.
## Mục lục

- [tree\_view\_flutter](#tree_view_flutter)
  - [Mục lục](#mục-lục)
  - [Tính năng](#tính-năng)
  - [Công nghệ sử dụng](#công-nghệ-sử-dụng)
  - [Nội dung](#nội-dung)
    - [Cấu trúc dữ liệu cây (Dart code)](#cấu-trúc-dữ-liệu-cây-dart-code)
    - [Hàm phụ trợ (Dart code)](#hàm-phụ-trợ-dart-code)
    - [Cây giao diện Flutter](#cây-giao-diện-flutter)
    - [Ví dụ khi parse data -\> cấu trúc dữ liệu cây](#ví-dụ-khi-parse-data---cấu-trúc-dữ-liệu-cây)
  - [BSD 3-Clause License](#bsd-3-clause-license)

## Tính năng

Một số tính năng mà thư viện này cung cấp:

- Tạo một cấu trúc dữ liệu kiểu cây (Dart code).
- Trực quan hoá cấu trúc cây bằng Flutter.
- Cho phép tuỳ chỉnh giao diện Flutter để phù hợp với nhu cầu sử dụng.
- Tính năng search.
- Chọn một hoặc nhiều node trên cây (nếu client cần chức năng "Cho vào danh sách yêu thích").
- Xây dựng cây với một số node không khả dụng (unvailable).
- Có thể sử dụng riêng cấu trúc dữ liệu cây tách biệt hoàn toàn với Flutter UI.

## Công nghệ sử dụng

- Quản lý trạng thái: `FutureBuilder`.

## Nội dung

### Cấu trúc dữ liệu cây (Dart code)

Ý tưởng từ cấu trúc của một cây thư mục trong máy tính, ta sẽ có 2 loại: thư mục và tệp. Một thư mục có thể chứa nhiều tệp và thư mục khác, và tệp là cấp độ bé nhất không thể chứa thêm gì nữa.

Tương tự cấu trúc cây thư mục trong máy tính, `tree_view_flutter` sẽ xây dựng một cấu trúc dữ liệu cây bao gồm inner node và leaf node.

- [AbsNodeType](lib/models/abstract_node_type.dart): Class trừu tượng cho kiểu dữ liệu của một node. Một node có thể là inner node và leaf node. Class này có các thuộc tính sau:
	- `id`: _required_, dynamic.
    - `title`: _required_, String.
    - `isInner`:  boolean, mặc định là **true**.
    - `isUnavailable`:  boolean, mặc định là **false**.
    - `isChosen`: nullable boolean, mặc định là **false**.
- [TreeType<T extends AbsNodeType>](lib/models/tree_type.dart): Class trừu tượng cho cấu trúc dữ liệu cây.
	- `T` là Implement Class của [AbsNodeType](lib/models/abstract_node_type.dart).
    - `data`: _required_, `T`. Dữ liệu (nội dung) trong node gốc của cây hiện tại.
    - `children`: _required_, `List<TreeType<T>>`. Danh sách những cây con.
    - `parent`: _required_, `TreeType<T>?`. Cha của cây hiện tại. Nếu `parent == null`, tức là ta đang ở root của toàn bộ cây.
    - `isLeaf`: Cây hiện tại đang ở node lá.
    - `isRoot`: Cây hiện tại đang ở node root.

### Hàm phụ trợ (Dart code)

- [tree_traversal_functions.dart](lib/functions/tree_traversal_functions.dart): Chứa các hàm liên quan đến duyệt cây:

    - [EChosenAllValues](lib/functions/tree_traversal_functions.dart#L4): Là kiểu `enum`, phục vụ cho các thao tác chọn/huỷ chọn trên cây, bao gồm 4 giá trị: `chosenAll`, `unchosenAll`, `chosenSome` & `notChosenable`.
    - [isChosenAll(tree)](lib/functions/tree_traversal_functions.dart#L7): Kiểm tra xem liệu các con của cây hiện tại có chọn hết, hoặc là không chọn cái nào cả, hoặc là chỉ một số được chọn, hoặc là không khả dụng.
    - [findRoot(tree)](lib/functions/tree_traversal_functions.dart#L69): Tìm gốc.
    - [findTreeWithId(tree, id)](lib/functions/tree_traversal_functions.dart#L74): Tìm cây với id dược cho.
    - [searchAllTreesWithTitleDFS(tree, text, result)](lib/functions/tree_traversal_functions.dart#L89): Tìm tất cả các cây nếu title data của root chứa searching text, dùng thuật toán DFS. Kết quả trả về được lưu trong biến `result`.
    - [searchLeavesWithTitleDFS(tree, text, result)](lib/functions/tree_traversal_functions.dart#L101): Tìm tất cả các lá nếu title data của lá chứa searching text, dùng thuật toán DFS. Kết quả trả về được lưu trong biến `result`.

- [tree_update_functions.dart](lib/functions/tree_update_functions.dart): Chứa các hàm liên quan đến cập nhập cây:

    - [updateAllUnavailableNodes(tree)](lib/functions/tree_update_functions.dart#L17): Cập nhập các giá trị `isUnavailable` của các node trong cây hiện tại. Giả sử khi ta parse data lần đầu tiên, một số lá sẽ unavailable và ta sẽ cần phải cập nhập luôn các inner node bị ảnh hưởng. Hàm trả về `true` nếu cây khả dụng (choosenable), ngược lại `false`.
    - [checkAll(tree)](lib/functions/tree_update_functions.dart#L34): check all.
    - [uncheckALl(tree)](lib/functions/tree_update_functions.dart#L46): uncheck all.
    - [updateTreeMultipleChoice(tree, chosenValue, isUpdatingParentRecursion)](lib/functions/tree_update_functions.dart#L62): Cập nhập cây (multiple choice) khi một node nào đó được tick.
    - [updateTreeSingleChoice(tree, chosenValue)](lib/functions/tree_update_functions.dart#L105): Cập nhập cây (single choice) khi một lá nào đó được tick.
    - [updateAncestorsToNull(tree)](lib/functions/tree_update_functions.dart#L129): Được sử dụng trong [updateTreeSingleChoice(tree, chosenValue)](lib/functions/tree_update_functions.dart#L105), dùng để update `isChosen` của tổ tiên cây hiện tại về `null`.

### Cây giao diện Flutter

- [StackTreeWidget](lib/widgets/stack_tree_widget.dart): Cây giao diện được xây dựng theo kiểu stack (multiple choice).

![StackTreeWidget Demo](readme_files/stack_tree_widget.mp4)

- [StackTreeSingleChoiceWidget](lib/widgets/stack_tree_single_choice_widget.dart): Cây giao diện được xây dựng theo kiểu stack (single choice).

![StackTreeSingleChoiceWidget Demo](readme_files/stack_tree_single_choice_widget.gif)

- [ExpandableTreeWidget](lib/widgets/expandable_tree_widget.dart): Cây giao diện được xây dựng theo kiểu expandable (multiple choice).

![ExpandableTreeWidget Demo](readme_files/expandable_tree_widget.gif)

- [ExpandableTreeSingleChoiceWidget](expandable_tree_single_choice_widget.dart): Cây giao diện được xây dựng theo kiểu expandable (single choice).

![ExpandableTreeSingleChoiceWidget Demo](readme_files/expandable_tree_single_choice_widget.gif)

- [TreeViewProperties](lib/widgets/tree_view_properties.dart): Các thuộc tính được dùng chung cho 2 kiểu cây giao diện [StackTreeWidget](lib/widgets/stack_tree_widget.dart) và [ExpandedTreeWidget](lib/widgets/expandable_tree_widget.dart).

### Ví dụ khi parse data -> cấu trúc dữ liệu cây

## BSD 3-Clause License
```
Copyright (c) 2023, Nguyễn Văn Biên

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

> **_NOTE:_**  Hoàng Sa, Trường Sa là của Việt Nam.
