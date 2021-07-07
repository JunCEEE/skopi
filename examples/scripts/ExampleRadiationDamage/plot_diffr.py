import h5py
import matplotlib.pyplot as plt
import matplotlib.colors as colors
from extra_geom import AGIPD_1MGeometry


geom = AGIPD_1MGeometry.from_crystfel_geom('./agipd_simple_2d.geom')
geom.inspect()

data_path='./diffr/diffr_out_0000001.h5'
# indices = slice(1:5)

data_f = h5py.File(data_path, 'r')
frame = data_f['data/0000001/diffr'][...]
fig, ax = plt.subplots(figsize=(12, 10))
geom.plot_data_fast(frame, axis_units='m', ax=ax, norm=colors.LogNorm());
plt.show()


# fig, ax = plt.subplots(figsize=(12, 10))
# geom.plot_data_fast(frame, axis_units='m', ax=ax, vmax=1000);
# with h5py.File(path, 'r') as h5:
#     root_path = '/data/0000001/'
#     pattern_type = 'diffr'
#     path_to_data = root_path + pattern_type
#     arr = h5[path_to_data][...]
# with h5py.File(path, 'r') as h5:
#     arr_size = len(indices)
#     pattern_shape = pattern_shape
#     arr = np.zeros((arr_size, pattern_shape[0], pattern_shape[1]))
#     for i, ix in enumerate(tqdm(indices)):
#                     root_path = '/data/%s/' % (ix)
#                     path_to_data = root_path + pattern_type
#                     arr[i] = h5[path_to_data][...]
